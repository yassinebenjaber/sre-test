# Simple AWS Order System
This is a student project using Terraform to connect two AWS Lambdas with an SQS queue.

- Lambda1 sends messages to the queue
- Lambda2 reads from it and logs to CloudWatch

Run:
terraform init
terraform apply

Then test with curl.
