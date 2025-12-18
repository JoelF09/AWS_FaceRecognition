#!/usr/bin/env bash
set -e
export AWS_PAGER=""

echo "===== AWS FaceRecognition – Init ====="

read -p "Name für IN-Bucket (z.B. m346inbucket): " IN_BUCKET
if [ -z "$IN_BUCKET" ]; then
  echo "Fehler: IN-Bucket-Name darf nicht leer sein."
  exit 1
fi

read -p "Name für OUT-Bucket (z.B. m346-joel-out): " OUT_BUCKET
if [ -z "$OUT_BUCKET" ]; then
  echo "Fehler: OUT-Bucket-Name darf nicht leer sein."
  exit 1
fi

read -p "AWS Region (Enter für us-east-1): " REGION
REGION=${REGION:-us-east-1}

read -p "Name für Lambda-Funktion: " FUNCTION_NAME
if [ -z "$FUNCTION_NAME" ]; then
    echo "Fehler: Lambda-Funktionsname darf nicht leer sein."
    exit 1
fi

ROLE_NAME="LabRole"       
STATEMENT_ID="${FUNCTION_NAME}-s3invoke"

echo
echo "=== Konfiguration ==="
echo "IN-Bucket:        $IN_BUCKET"
echo "OUT-Bucket:       $OUT_BUCKET"
echo "Region:           $REGION"
echo "IAM-Rolle:        $ROLE_NAME"
echo "Lambda-Funktion:  $FUNCTION_NAME"
echo

if [ ! -f "lambda.zip" ]; then
  echo "ERROR: lambda.zip nicht gefunden. Bitte im Projekt-Hauptordner ausführen und vorher die Lambda-Funktion zippen."
  echo "Beispiel:"
  echo "  cd lambda"
  echo "  zip ../lambda.zip lambda_function.py"
  exit 1
fi

create_bucket () {
  local BUCKET_NAME="$1"

  if aws s3api head-bucket --bucket "$BUCKET_NAME" >/dev/null 2>&1; then
    echo "Bucket $BUCKET_NAME existiert bereits, überspringe."
    return
  fi

  echo "Erstelle Bucket: $BUCKET_NAME"

  if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --region "$REGION"
  else
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --region "$REGION" \
      --create-bucket-configuration LocationConstraint="$REGION"
  fi
}

echo "=== Creating S3 buckets ==="
create_bucket "$IN_BUCKET"
create_bucket "$OUT_BUCKET"
echo