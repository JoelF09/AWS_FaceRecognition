#!/usr/bin/env bash
set -e
export AWS_PAGER=""

PREFIX="m346"                 
REGION="us-east-1"            

IN_BUCKET="${PREFIX}-in"
OUT_BUCKET="${PREFIX}-out"
ROLE_NAME="LabRole"          
FUNCTION_NAME="${PREFIX}-facerecognition"

