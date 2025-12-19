#!/usr/bin/env bash

set -e

# Das Skript wird bei jedem Fehler sofort beendet
# Dadurch werden Folgefehler vermieden
 
echo "===== AWS FaceRecognition – Test ====="

# Abfrage des Eingabe Buckets
 
read -p "Name des IN-Buckets: " IN_BUCKET

if [ -z "$IN_BUCKET" ]; then

  echo "Fehler: IN-Bucket-Name darf nicht leer sein."

  exit 1

fi

# Abfrage des Ausgabe Buckets
 
read -p "Name des OUT-Buckets: " OUT_BUCKET

if [ -z "$OUT_BUCKET" ]; then

  echo "Fehler: OUT-Bucket-Name darf nicht leer sein."

  exit 1

fi

# Abfrage der AWS Region mit Standardwert
 
read -p "AWS Region (Enter für us-east-1): " REGION

REGION=${REGION:-us-east-1}

# Abfrage des Testbild Pfades
 
read -p "Pfad zum Testbild (Default: testdata/angelina.png): " TEST_IMAGE

TEST_IMAGE=${TEST_IMAGE:-testdata/angelina.png}

# Prüfung ob das Testbild existiert
 
if [ ! -f "$TEST_IMAGE" ]; then

  echo "Fehler: Testbild $TEST_IMAGE existiert nicht."S

  exit 1

fi

# Extrahiert den Dateinamen aus dem Bildpfad
 
KEY=$(basename "$TEST_IMAGE")

# Erwarteter Name der Ergebnis Datei

OUT_KEY="${KEY}.json"
 
echo

echo "=== Uploading test image ==="

# Upload des Testbildes in den Eingabe Bucket

aws s3 cp "$TEST_IMAGE" "s3://$IN_BUCKET/$KEY" --region "$REGION"
 
echo "=== Waiting for result JSON in out-bucket ==="

# Warteschleife auf das Ergebnis JSON
 
for i in {1..20}; do

  if aws s3 ls "s3://$OUT_BUCKET/$OUT_KEY" --region "$REGION" > /dev/null 2>&1; then

    echo "Result file found!"

    aws s3 cp "s3://$OUT_BUCKET/$OUT_KEY" out.json --region "$REGION"

    break

  fi

  echo "No result yet... retry $i"

  sleep 3

done

# Prüfung ob das Ergebnis geladen wurde
 
if [ ! -f out.json ]; then

  echo "ERROR: No result JSON found after waiting."

  exit 1

fi
 
echo "=== Recognized celebrities (detailliert) ==="

# Formatierte Ausgabe falls jq installiert ist

if command -v jq >/dev/null 2>&1; then

  jq '{

    recognized_count: (.CelebrityFaces | length),

    unrecognized_count: (.UnrecognizedFaces | length),

    celebrities: [

      .CelebrityFaces[] |

      {

        name: .Name,

        id: .Id,

        match_confidence: .MatchConfidence,

        known_gender: .KnownGender.Type,

        urls: .Urls,

        face_confidence: .Face.Confidence,

        bounding_box: .Face.BoundingBox

      }

    ]

  }' out.json

else

  echo "Install jq für schönere Ausgabe. Raw JSON:"

  cat out.json

fi