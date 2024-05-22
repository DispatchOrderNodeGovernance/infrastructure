
output "api_gateway_endpoint" {
  value = "${aws_apigatewayv2_api.api_gateway.api_endpoint}/${
    aws_apigatewayv2_stage.api_gateway.name
  }"
}