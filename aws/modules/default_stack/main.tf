resource "aws_dynamodb_table_item" "default_stack" {
  table_name = var.contract_templates_table_name
  hash_key   = "id"
  range_key  = "beneficiary_id"

  item = <<ITEM
{
  "id": {"N": "2"},
  "beneficiary_id": {"N": "2"}
}
ITEM
}
