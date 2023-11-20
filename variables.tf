
variable "user_path" {
  type = string
  default = "test"
}

variable "users" {
  type    = map(map(string))
  default = {}
}

# SES configuration 
# https://docs.aws.amazon.com/ses/latest/dg/send-an-email-using-sdk-programmatically.html
variable "sender" {
  type = string
  default = "Sender Name <sender@example.com>"
}
variable "recepient" {
  type = string
  default = "recipient@example.com"
}



