terraform {
  required_version = ">= 0.12"
}

provider "aws" {
}


module "aws_tokens" {
  source      = "mnecas/tokens/aws"
  version     = "0.0.3"
  users       = var.aws_users
  webhook_url = var.webhook_url
  user_prefix = var.user_prefix
}

provider "google" {
  project     = "honeytokens-401815"
  region      = "us-central1"
}

module "gcp_tokens" {
  source      = "mnecas/tokens/gcp"
  version     = "0.0.4"
  users       = var.gcp_users
  webhook_url = var.webhook_url
  user_prefix = var.user_prefix
}
