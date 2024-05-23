resource "aws_dynamodb_table_item" "default_stack" {
  table_name = var.contract_templates_table_name
  hash_key   = "id"

  item = <<ITEM
{
  "id": {"N": "2"},
  "beneficiary_id": {"N": "2"},
  "total_contract_value": {"N": "0"}
}
ITEM
}

/*
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['CONTRACT_TEMPLATES_TABLE_NAME']
table = dynamodb.Table(table_name)
table.get_item(Key={'id': 2})
*/

