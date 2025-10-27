# Simple SQS queue for orders
resource "aws_sqs_queue" "order_queue" {
  name                       = "${var.project_name}-queue"
  visibility_timeout_seconds = 30       # seconds a message stays invisible while being processed
  message_retention_seconds  = 86400    # 1 day retention
  receive_wait_time_seconds  = 5        # reduce API throttling for polling Lambdas

  tags = {
    Project = var.project_name
  }
}
