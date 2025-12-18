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

echo "=== Using existing IAM role ==="
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
echo "Account ID: $ACCOUNT_ID"
echo "Role ARN:   $ROLE_ARN"
echo

echo "=== Creating Lambda function ==="

if aws lambda get-function --function-name "$FUNCTION_NAME" --region "$REGION" >/dev/null 2>&1; then
  echo "Lambda-Funktion $FUNCTION_NAME existiert bereits, überspringe create-function."
else
  aws lambda create-function \
    --function-name "$FUNCTION_NAME" \
    --runtime python3.12 \
    --role "$ROLE_ARN" \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://lambda.zip \
    --environment "Variables={OUT_BUCKET=$OUT_BUCKET}" \
    --timeout 30 \
    --memory-size 256 \
    --region "$REGION"
  echo "Lambda-Funktion $FUNCTION_NAME erstellt."
fi
echo

echo "=== Adding permission for S3 to invoke Lambda ==="

aws lambda add-permission \
  --function-name "$FUNCTION_NAME" \
  --statement-id "$STATEMENT_ID" \
  --action "lambda:InvokeFunction" \
  --principal s3.amazonaws.com \
  --source-arn "arn:aws:s3:::$IN_BUCKET" \
  --region "$REGION" 2>/tmp/add-perm.err || {
    if grep -q "ResourceConflictException" /tmp/add-perm.err; then
      echo "Permission existiert bereits, überspringe."
    else
      echo "Fehler bei add-permission:"
      cat /tmp/add-perm.err
      exit 1
    fi
  }

echo