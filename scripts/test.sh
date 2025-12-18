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


