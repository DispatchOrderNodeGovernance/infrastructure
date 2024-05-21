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
  lambda_get_contract_templates_arn = module.lambda.get_contract_templates_lambda_arn
}
