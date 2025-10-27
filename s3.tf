resource "aws_s3_bucket" "lambda_logs" {
  bucket        = "${var.project_name}-logs-${var.suffix}"
  force_destroy = true
  tags = {
    Project = "${var.project_name}-${var.suffix}"
  }
}
