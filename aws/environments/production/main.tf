terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}
module "dynamodb" {
  source                        = "../../modules/dynamodb"
  contract_templates_table_name = "contract_templates_${var.environment}"
}

module "lambda" {
  source                                = "../../modules/lambda"
  environment                           = var.environment
  dynamodb_table_contract_templates_arn = module.dynamodb.contract_templates_table_arn
  dispatch_endpoint                     = module.api_gateway.api_gateway_endpoint
  location_service_endpoints            = "${module.api_gateway.api_gateway_endpoint}/locations"
  notification_service_endpoints    = "${module.api_gateway.api_gateway_endpoint}/notifications"
  ride_matching_service_endpoints   = "${module.api_gateway.api_gateway_endpoint}/rides"
  trip_management_service_endpoints = "${module.api_gateway.api_gateway_endpoint}/trips"
  dynamodb_table_contract_templates_name = module.dynamodb.contract_templates_table_name
}

module "default_stack" {
  source                            = "../../modules/default_stack"
  contract_templates_table_name     = module.dynamodb.contract_templates_table_name
  location_service_endpoints        = "${module.api_gateway.api_gateway_endpoint}/locations"
  notification_service_endpoints    = "${module.api_gateway.api_gateway_endpoint}/notifications"
  ride_matching_service_endpoints   = "${module.api_gateway.api_gateway_endpoint}/rides"
  trip_management_service_endpoints = "${module.api_gateway.api_gateway_endpoint}/trips"
}

module "api_gateway" {
  source                            = "../../modules/api_gateway"
  update_location_lambda_arn        = module.lambda.update_location_lambda_arn
  lambda_get_contract_templates_arn = module.lambda.get_contract_templates_lambda_arn
  dispatch_lambda_arn               = module.lambda.dispatch_lambda_arn
  api_gateway_name                  = "api_gateway_${var.environment}"
}

data "http" "api_gateway_get_stacks" {
  depends_on = [module.api_gateway, module.lambda, module.dynamodb]
  url        = "${module.api_gateway.api_gateway_endpoint}/stacks"
}
data "http" "api_gateway_update_location" {
  url    = "${module.api_gateway.api_gateway_endpoint}/locations"
  method = "POST"
  request_body = jsonencode({
    "longitude" : 105.84401565986708,
    "latitude" : 21.001407164932232,
    "driver_id" : "value_${timestamp()}",
    "status" : "in_trip"
  })
  request_headers = {
    "Content-Type" = "application/json"
  }
}
resource "local_file" "api_gateway_get_stacks" {
  content  = data.http.api_gateway_get_stacks.response_body
  filename = "stacks.json"
}
resource "local_file" "api_gateway_update_location" {
  content  = data.http.api_gateway_update_location.response_body
  filename = "update_location.json"
}
/*
{
  "rider_id": "rider123",
  "pickup_location": {
    "latitude": 37.7749,
    "longitude": -122.4194
  },
  "destination_location": {
    "latitude": 37.7849,
    "longitude": -122.4094
  },
  "stack_id": "stack123"
}
*/
