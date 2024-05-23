# An API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
}

#update_location_lambda_arn 


resource "aws_apigatewayv2_route" "api_gateway_dispatch" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /dispatch"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_dispatch.id}"
}
resource "aws_apigatewayv2_integration" "api_gateway_dispatch" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = var.dispatch_lambda_arn
  payload_format_version = "2.0"
}
resource "aws_lambda_permission" "api_gateway_dispatch" {
  statement_id  = "AllowExecutionDispatch"
  action        = "lambda:InvokeFunction"
  function_name = var.dispatch_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/${aws_apigatewayv2_stage.api_gateway.name}/POST/dispatch"
}
resource "aws_apigatewayv2_route" "api_gateway_update_location" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /locations"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_update_location.id}"
}
resource "aws_apigatewayv2_integration" "api_gateway_update_location" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = var.update_location_lambda_arn
  payload_format_version = "2.0"
}

resource "aws_lambda_permission" "api_gateway_update_location" {
  statement_id  = "AllowExecutionUpdateLocation"
  action        = "lambda:InvokeFunction"
  function_name = var.update_location_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/${aws_apigatewayv2_stage.api_gateway.name}/POST/locations"
}

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
resource "aws_lambda_permission" "api_gateway_get_stacks" {
  statement_id  = "AllowExecutionGetStacks"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_get_contract_templates_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/${aws_apigatewayv2_stage.api_gateway.name}/GET/stacks"
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
