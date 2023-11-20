import json
import time
import boto3
import gzip
import os
from jinja2 import Environment, FileSystemLoader
from botocore.exceptions import ClientError


USER_PATH = os.environ["USER_PATH"]
AWS_REGION = os.environ["REGION"]
RECIPIENT = os.environ["RECIPIENT"]
SENDER = os.environ["SENDER"]

def send_ses(username, tags, source_ip_address):
    CHARSET = "UTF-8"
    SUBJECT = f"Honeytoken triggered by '{username}'"

    environment = Environment(loader=FileSystemLoader("."))
    template = environment.get_template("message.j2")
    BODY_HTML = template.render(tags=tags, username=username,ip=source_ip_address)

    client = boto3.client("ses", region_name=AWS_REGION)
    try:
        # Provide the contents of the email.
        client.send_email(
            Destination={
                "ToAddresses": [
                    RECIPIENT,
                ],
            },
            Message={
                "Body": {
                    "Html": {
                        "Charset": CHARSET,
                        "Data": BODY_HTML,
                    },
                    "Text": {
                        "Charset": CHARSET,
                        "Data": "username: '{username}', tags: {tags}",
                    },
                },
                "Subject": {
                    "Charset": CHARSET,
                    "Data": SUBJECT,
                },
            },
            Source=SENDER,
        )
    except ClientError as e:
        print(e.response["Error"]["Message"])
    else:
        print("Email sent!"),


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
            response = boto3.client("iam").list_user_tags(UserName=arn_split[2])
            print("Sending report")
            send_ses(arn_split[2], response["Tags"], record.get("sourceIPAddress"))

    return

