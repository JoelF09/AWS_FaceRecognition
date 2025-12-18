#!/usr/bin/env bash
set -e
export AWS_PAGER=""

PREFIX="m346"                 
REGION="us-east-1"            

IN_BUCKET="${PREFIX}-in"
OUT_BUCKET="${PREFIX}-out"
ROLE_NAME="LabRole"          
FUNCTION_NAME="${PREFIX}-facerecognition"

echo "=== Using prefix: $PREFIX ==="
echo "Region:   $REGION"
echo "In-Bucket:  $IN_BUCKET"
echo "Out-Bucket: $OUT_BUCKET"
echo "Role:     $ROLE_NAME"
echo "Function: $FUNCTION_NAME"
echo "=============================="

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

echo "=== Using existing IAM role ==="
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
echo "Account ID: $ACCOUNT_ID"
echo "Role ARN:   $ROLE_ARN"
echo