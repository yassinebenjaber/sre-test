# Simple HTTP API for sending orders
resource "aws_apigatewayv2_api" "api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}

# Connect API Gateway to the AddOrder Lambda
resource "aws_apigatewayv2_integration" "add_order_integration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.add_order.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"

  depends_on = [aws_lambda_function.add_order]
}

# Route: POST /orders
resource "aws_apigatewayv2_route" "post_orders" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /orders"
  target    = "integrations/${aws_apigatewayv2_integration.add_order_integration.id}"
}

# Allow API Gateway to invoke the Lambda
resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_order.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"

  depends_on = [aws_lambda_function.add_order]
}

# Default stage (auto-deployed)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}
