output "api_url" {
  value = aws_apigatewayv2_stage.default.invoke_url
}

output "queue_name" {
  value = aws_sqs_queue.order_queue.name
}
