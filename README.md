# AWS Serverless Order System (Terraform + GitHub Actions)

This project deploys a simple, serverless order processing system on AWS.

It uses **Terraform** to define the infrastructure (API Gateway, Lambda, SQS, S3) and **GitHub Actions** (`deploy.yml`) to automatically build and deploy the system on every push to the `main` branch.

---

##  Deployment & Validation

The `deploy.yml` GitHub Actions pipeline runs successfully, automatically provisioning a new S3 bucket + Suffix for each deployment.

### Test Proof

The system was tested by sending a POST request to the deployed API Gateway endpoint from my local WSL terminal.

**1. S3 Bucket Created**

The pipeline successfully created the S3 bucket for storing logs.

<img width="1037" height="542" alt="s3 created" src="https://github.com/user-attachments/assets/b1100489-7e0a-4a39-873e-79cf3fd3a584" />
*(Image: AWS Console showing the S3 log bucket)*

**2. Local `curl` Test**

<img width="570" height="204" alt="curl" src="https://github.com/user-attachments/assets/0cfd90ca-176b-40c1-987c-f75867b6307d" />

**3. Log Stored in S3**

The "Process Order" Lambda successfully processed the order from the SQS queue and stored the corresponding log file in the S3 bucket.

<img width="1543" height="719" alt="log" src="https://github.com/user-attachments/assets/c9aa2568-724f-4506-9e38-b16b90c07a2d" />

---

## 🧭 Future Improvements

This is a foundational project. It could be expanded by:

* **Adding a Database**: Use **DynamoDB** to store order data persistently instead of just logging to S3.
* **Remote State**: Implementing a **Terraform remote backend** (using S3 and DynamoDB) for better state management and team collaboration.
* **Monitoring**: Adding **CloudWatch Alarms** to get alerts for failed Lambda executions or messages in the SQS Dead-Letter Queue (DLQ).
* **Security**: Integrating security scanning tools like `tfsec` or `Trivy` into the CI/CD pipeline.
