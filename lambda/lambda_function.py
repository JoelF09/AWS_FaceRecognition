import boto3
import json
import os

# AWS Rekognition Client für Bildanalyse 
rekognition = boto3.client("rekognition")

# AWS S3 Client für Dateioperationen
s3 = boto3.client("s3")

# Ziel Bucket für die Ausgabe 
OUT_BUCKET = os.environ.get("OUT_BUCKET", "")

def lambda_handler(event, context):
    """
    Einstiegspunkt der AWS-Lambda-Funktion.
    Wird automatisch ausgelöst, z. B. durch ein S3-Event (Datei-Upload).
    """

    # Loggt das komplette Event zur Analyse und zum Debugging
    print("Event:", json.dumps(event))

    # Iteration über alle Records im Event 
    for record in event["Records"]:
        # Quell Bucket Name aus dem S3-Event
        bucket = record["s3"]["bucket"]["name"]

        # Objekt-Key (Dateiname inkl. Pfad)
        key = record["s3"]["object"]["key"]

        # Prüft, ob es sich um ein unterstütztes Bildformat handelt
        if not key.lower().endswith((".jpg", ".jpeg", ".png")):
            print(f"Skipping non-image file: {key}")
            continue

        # Aufruf von AWS Rekognition zur Erkennung von Prominenten im Bild
        response = rekognition.recognize_celebrities(
            Image={"S3Object": {"Bucket": bucket, "Name": key}}
        )

        # Ziel-Dateiname für das Analyse Ergebnis
        out_key = key + ".json"

        # Speichert die Rekognition Antwort als JSON im Ziel S3 Bucket
        s3.put_object(
            Bucket=OUT_BUCKET,
            Key=out_key,
            Body=json.dumps(response, indent=2),
            ContentType="application/json"
        )

    # Rückgabewert der Lambda Funktion
    return {"statusCode": 200, "body": "OK"}
