resource "aws_s3_bucket" "lambda_logs" {
  bucket = "${var.project_name}-logs"
}
