module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  source_path = [
    {
      path             = "${path.module}/lambda/",
      pip_requirements = "${path.module}/lambda/requirements.txt"
    }
  ]
  function_name = "honeytokens_lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  timeout       = 30
  publish       = true

  allowed_triggers = {
    AllowExecutionFromS3Bucket = {
      service    = "s3"
      source_arn = aws_s3_bucket.honeytokens_bucket.arn
    }
  }

  environment_variables = {
    USER_PATH   = var.user_prefix,
    WEBHOOK_URL = var.webhook_url
    # RECIPIENT = var.recepient,
    # SENDER = var.sender,
    # REGION = data.aws_region.current.name
  }
  assume_role_policy_statements = {
    assume_role = {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = {
        account_principals = {
          type        = "Service"
          identifiers = ["lambda.amazonaws.com"]
        }
      }
    }
  }

  cloudwatch_logs_retention_in_days = 90
  attach_cloudwatch_logs_policy     = true
  attach_policy_statements          = true
  policy_statements = {
    get_object = {
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["arn:aws:s3:::${aws_s3_bucket.honeytokens_bucket.bucket}/honeytokens/*"]
    }
    list_user_tags = {
      effect = "Allow"
      actions = [
        "iam:ListUserTags",
      ]
      resources = ["*"]
    }
    ses_send_email = {
      effect = "Allow"
      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ]
      resources = ["*"]
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.honeytokens_bucket.id

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "honeytokens/AWSLogs/"
    filter_suffix       = ".json.gz"
  }
  depends_on = [module.lambda_function]
}
