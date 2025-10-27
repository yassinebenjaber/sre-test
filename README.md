# AWS Order System (Terraform + GitHub Actions)

This project deploys a simple **Order Processing System** using Terraform and GitHub Actions.

## Architecture
- **API Gateway** → triggers → **Lambda (Add Order)**
- **Add Order Lambda** → sends message → **SQS Queue**
- **SQS Queue** → triggers → **Lambda (Process Order)**
- Both Lambdas log events → **S3 bucket**
