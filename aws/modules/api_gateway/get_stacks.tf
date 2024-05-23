

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
