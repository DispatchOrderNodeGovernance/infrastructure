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
  source                                 = "../../modules/lambda"
  environment                            = var.environment
  dynamodb_table_contract_templates_arn  = module.dynamodb.contract_templates_table_arn
  dynamodb_table_contract_templates_name = module.dynamodb.contract_templates_table_name
}

module "default_stack" {
  source                        = "../../modules/default_stack"
  contract_templates_table_name = module.dynamodb.contract_templates_table_name
}

module "api_gateway" {
  source                            = "../../modules/api_gateway"
  update_location_lambda_arn        = module.lambda.update_location_lambda_arn
  lambda_get_contract_templates_arn = module.lambda.get_contract_templates_lambda_arn
  api_gateway_name                  = "api_gateway_${var.environment}"
}

data "http" "api_gateway" {
  url = "${module.api_gateway.api_gateway_endpoint}/stacks"
}
resource "local_file" "api_gateway" {
  content  = data.http.api_gateway.response_body
  filename = "api_gateway.json"
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
