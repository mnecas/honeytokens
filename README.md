# Honeytokens

This is a POC repository of honeytokens using GCP/AWS to monitor the token usage.

Honeytokens are real user tokens without any privileges and with configured logging and reporting on the user activity.
These tokens are placed across the infrastructure to the servers, git projects, each point of the trusted supply chain, etc. 


## Modules
- [mnecas/tokens/aws](https://github.com/mnecas/terraform-aws-tokens) 
- [mnecas/tokens/gcp](https://github.com/mnecas/terraform-gcp-tokens) 


## Configuration
```
aws_users = {
  admin-user1 = {
    server = "192.168.2.23"
  }
  admin-user2 = {}
}

gcp_users = {
  admin-user3 = {
    # WARNING only 256 char possible labels in TOTAL
    server = "192.168.2.24",
    test = "asdasd"
  }
  admin-user4 = {}
}

user_prefix="infra"

# Slack config
webhook_url = "https://hooks.slack.com/TXXXXX/BXXXXX/XXXXXXXXXX"
```

## Deployment

```bash
# Inicilize the Terraform project
$ terraform init
# Edit the 
$ terraform apply
$ terraform output -json honeytokens_access_keys | jq
```