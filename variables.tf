
variable "user_prefix" {
  type    = string
  default = "test"
}

variable "aws_users" {
  type    = map(map(string))
  default = {}
}

variable "gcp_users" {
  type    = map(map(string))
  default = {}
}

# Slack configuration
variable "webhook_url" {
  type    = string
  default = "https://hooks.slack.com/TXXXXX/BXXXXX/XXXXXXXXXX"
}


