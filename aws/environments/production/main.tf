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
  contract_templates_table_name = "contract_templates_${terraform.workspace}"
}
