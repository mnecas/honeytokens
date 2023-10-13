# Honeytokens using GCP
Create a service account with key which can be installed in the testing enviroment.
Configure alert trigger on the create service account with parameters:
- Consumed API -> API -> Request count
- Filter credential_id = *service account ID*
- Condition Types: Threshold above 0, Alter trigger anytime series violates. (This makes sure to get an alert whenever the token is used.)
- Rolling window: **Does not matter for this usecase?**
- Configure notifications and finalize alert -> **Notification channels** (needs to be configure by user)


Needed to use terraform, the ansible does not have configuration of the alert policy.
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy.html
