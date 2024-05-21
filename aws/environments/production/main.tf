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
  source      = "../../modules/lambda"
  environment = terraform.workspace
  dynamodb_table_contract_templates_arn = module.dynamodb.contract_templates_table_arn
  dynamodb_table_contract_templates_name = module.dynamodb.contract_templates_table_name
}
