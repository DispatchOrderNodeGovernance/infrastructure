# An API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gateway" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "production_stage"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 1 # Maximum number of requests that are allowed in a burst, burst is the maximum number of requests that API Gateway allows to pass through at once
    throttling_rate_limit  = 3
    # Maximum number of requests that are allowed per second (maximum requests a month is 60 * 60 * 24 * 30 * 0.05 = 518400)
  }
}
