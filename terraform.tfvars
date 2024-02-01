aws_users = {
  admin-user1 = {
    server = "192.168.2.23"
    owner = "@mnecas"
  }
  admin-user2 = {}
}

gcp_users = {
  admin-user3 = {
    server = "192.168.2.24",
    test = "asdasd"
    owner = "@mnecas"
  }
  admin-user4 = {}
}

user_prefix="infra"

# Slack config
webhook_url = "https://hooks.slack.com/TXXXXX/BXXXXX/XXXXXXXXXX"
