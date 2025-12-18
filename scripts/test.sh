#!/usr/bin/env bash

set -e
 
echo "===== AWS FaceRecognition – Test ====="
 
read -p "Name des IN-Buckets: " IN_BUCKET

if [ -z "$IN_BUCKET" ]; then

  echo "Fehler: IN-Bucket-Name darf nicht leer sein."

  exit 1

fi
 
read -p "Name des OUT-Buckets: " OUT_BUCKET

if [ -z "$OUT_BUCKET" ]; then

  echo "Fehler: OUT-Bucket-Name darf nicht leer sein."

  exit 1

fi
 
read -p "AWS Region (Enter für us-east-1): " REGION

REGION=${REGION:-us-east-1}
 
read -p "Pfad zum Testbild (Default: testdata/angelina.png): " TEST_IMAGE

TEST_IMAGE=${TEST_IMAGE:-testdata/angelina.png}
 
if [ ! -f "$TEST_IMAGE" ]; then

  echo "Fehler: Testbild $TEST_IMAGE existiert nicht."S

  exit 1

fi
 
KEY=$(basename "$TEST_IMAGE")

OUT_KEY="${KEY}.json"
 
echo

echo "=== Uploading test image ==="

aws s3 cp "$TEST_IMAGE" "s3://$IN_BUCKET/$KEY" --region "$REGION"
 
echo "=== Waiting for result JSON in out-bucket ==="
 
for i in {1..20}; do

  if aws s3 ls "s3://$OUT_BUCKET/$OUT_KEY" --region "$REGION" > /dev/null 2>&1; then

    echo "Result file found!"

    aws s3 cp "s3://$OUT_BUCKET/$OUT_KEY" out.json --region "$REGION"

    break

  fi

  echo "No result yet... retry $i"

  sleep 3

done
 
if [ ! -f out.json ]; then

  echo "ERROR: No result JSON found after waiting."

  exit 1

fi
 
echo "=== Recognized celebrities (detailliert) ==="

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
 $
 