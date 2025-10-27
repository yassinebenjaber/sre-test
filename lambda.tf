# Lambda that sends messages to SQS
resource "aws_lambda_function" "add_order" {
  function_name = "${var.project_name}-add"
  runtime       = "python3.12"
  handler       = "main.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda/add_order.zip"
  timeout       = 10 # prevent premature timeout while sending or logging

  environment {
    variables = {
      QUEUE_URL  = aws_sqs_queue.order_queue.id
      LOG_BUCKET = aws_s3_bucket.lambda_logs.bucket
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_sqs_access,
    aws_iam_role_policy.lambda_s3_access
  ]
}

# Lambda that processes messages from SQS
resource "aws_lambda_function" "process_order" {
  function_name = "${var.project_name}-process"
  runtime       = "python3.12"
  handler       = "main.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda/process_order.zip"
  timeout       = 10

  depends_on = [
    aws_iam_role_policy.lambda_sqs_access
  ]
}

# Connect SQS queue to the processor Lambda
resource "aws_lambda_event_source_mapping" "sqs_to_process" {
  event_source_arn = aws_sqs_queue.order_queue.arn
  function_name    = aws_lambda_function.process_order.arn
}
