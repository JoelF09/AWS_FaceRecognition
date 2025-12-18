#!/usr/bin/env bash
set -e
 
PREFIX="m346"          
REGION="us-east-1"    
 
IN_BUCKET="${PREFIX}-in"
OUT_BUCKET="${PREFIX}-out"
 
TEST_IMAGE="testdata/angelina.png"  
KEY=$(basename "$TEST_IMAGE")
OUT_KEY="${KEY}.json"

echo "=== Uploading test image ==="
aws s3 cp "$TEST_IMAGE" "s3://$IN_BUCKET/$KEY" --region "$REGION"