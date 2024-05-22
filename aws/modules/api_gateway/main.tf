# An API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
  target        = var.lambda_get_contract_templates_arn
}

#update_location_lambda_arn 

resource "aws_apigatewayv2_route" "api_gateway_get_stacks" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /stacks"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_get_stacks.id}"
}
resource "aws_apigatewayv2_integration" "api_gateway_get_stacks" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_method     = "GET"
  integration_uri        = var.lambda_get_contract_templates_arn
  payload_format_version = "2.0"
}
resource "aws_apigatewayv2_stage" "api_gateway" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "production_stage"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 1
    throttling_rate_limit  = 1
  }
}

/* Invoke permissions
The resource policy of the Lambda function determines if API Gateway can invoke it. You can run the AWS CLI command snippet below to give API Gateway permission to invoke your AWS Lambda function.
 */

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_get_contract_templates_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_apigatewayv2_api.api_gateway.execution_arn
}

