resource "aws_cloudtrail" "honeytokens_cloudtrail" {
  name                          = "honeytokens_cloudtrail"
  s3_bucket_name                = aws_s3_bucket.honeytokens_bucket.id
  s3_key_prefix                 = "honeytokens"
  include_global_service_events = true
  is_multi_region_trail         = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  depends_on = [aws_s3_bucket_policy.honeytokens_bucket_policy]
}

data "aws_iam_policy_document" "honeytokens_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.honeytokens_bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/honeytokens_cloudtrail"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.honeytokens_bucket.arn}/honeytokens/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/honeytokens_cloudtrail"]
    }
  }
}

resource "aws_s3_bucket" "honeytokens_bucket" {
  bucket        = "honeytokens-logs"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "honeytokens_bucket_policy" {
  bucket = aws_s3_bucket.honeytokens_bucket.id
  policy = data.aws_iam_policy_document.honeytokens_policy.json
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.honeytokens_bucket.id

  rule {
    id     = "log"
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}
