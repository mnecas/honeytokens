import json
import boto3
import gzip
import os
from utils import *


WEBHOOK_URL = os.environ["WEBHOOK_URL"]
USER_PATH = os.environ["USER_PATH"]


def fetch_log_records(bucket, key):
    """Return the list of log records from the given ``bucket`` and ``key``."""
    response = boto3.client("s3").get_object(Bucket=bucket, Key=key)
    json_data = gzip.decompress(response["Body"].read())
    data = json.loads(json_data)
    return data.get("Records", [])


def lambda_handler(event, context):
    src_bucket = event["Records"][0]["s3"]["bucket"]["name"]
    src_key = event["Records"][0]["s3"]["object"]["key"]
    # Record from the bucket
    records = fetch_log_records(src_bucket, src_key)
    print(f"Fetched log file with {len(records)} entries")
    for record in records:
        arn = record.get("userIdentity", {}).get("arn")
        if not arn:
            continue
        arn_split = arn.split("/")
        # The honeytoken ARN is in format: arn:aws:iam::account:user/user-name-with-path/name
        if len(arn_split) == 3 and arn_split[1] == USER_PATH:
            print("Record")
            print(record)
            metadata = AwsMetadata(record)
            slack = SlackRequest(WEBHOOK_URL)
            slack.send(metadata)

    return
