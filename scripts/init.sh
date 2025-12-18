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

STATEMENT_ID="${PREFIX}-s3invoke"

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
      cat /tmp/add-perm.err
      exit 1
    fi
  }

echo