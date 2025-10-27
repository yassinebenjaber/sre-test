# Simple SQS queue for orders
resource "aws_sqs_queue" "order_queue" {
  name                       = "${var.project_name}-queue-${var.suffix}"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 5

  tags = {
    Project = "${var.project_name}-${var.suffix}"
  }
}
