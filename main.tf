terraform {
  required_version = ">= 0.12"
}

provider "aws" {
}

provider "google" {
  credentials = file("../admin.json")
  project     = "honeytokens-401815"
  region      = "us-central1"
}

module "aws_tokens" {
  source = "./modules/aws_tokens"
  users = var.aws_users
  webhook_url = var.webhook_url
  user_prefix = var.user_prefix
}

module "gcp_tokens" {
  source = "./modules/gcp_tokens"
  users = var.gcp_users
  webhook_url = var.webhook_url
  user_prefix = var.user_prefix
}