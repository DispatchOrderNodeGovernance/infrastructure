
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

