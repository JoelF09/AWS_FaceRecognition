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