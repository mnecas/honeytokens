# Honeytokens using AWS
- Create AWS cloudtrail which logs to the S3 bucket, create with the cloudtrail also cloudwatch for alerts
- Create CloudWatch Log group metric filter, which will monitor the S3 bucket
- Create Cloudwatch Alarm base on the metric filter
- Choose **SNS topic** (user should provide/have precreated)
  - SNS can be configured to many applications including slack
https://youtu.be/M3bVQT6cvRI?si=m55KDBZ3rOQFR7Xw
- 