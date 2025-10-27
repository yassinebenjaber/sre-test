output "deployment_id" {
  description = "Unique suffix for this deployment"
  value       = var.suffix
}

output "api_url" {
  description = "Invoke URL for this API Gateway deployment"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "queue_name" {
  description = "SQS queue name used by this deployment"
  value       = aws_sqs_queue.order_queue.name
}
