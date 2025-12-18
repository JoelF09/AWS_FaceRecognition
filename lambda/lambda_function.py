import boto3
import json
import os
 
rekognition = boto3.client("rekognition")
s3 = boto3.client("s3")
 
OUT_BUCKET = os.environ.get("OUT_BUCKET", "")
 
def lambda_handler(event, context):
    print("Event:", json.dumps(event))
 
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
 
        if not key.lower().endswith((".jpg", ".jpeg", ".png")):
            print(f"Skipping non-image file: {key}")
            continue
 
        response = rekognition.recognize_celebrities(
            Image={"S3Object": {"Bucket": bucket, "Name": key}}
        )
 
        out_key = key + ".json"
        s3.put_object(
            Bucket=OUT_BUCKET,
            Key=out_key,
            Body=json.dumps(response, indent=2),
            ContentType="application/json"
        )
 
    return {"statusCode": 200, "body": "OK"}
 
 