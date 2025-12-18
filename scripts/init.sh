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

