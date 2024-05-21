
# output module.dynamodb.contract_templates_table_arn
output "contract_templates_table_arn" {
    value = aws_dynamodb_table.contract_templates.arn
}
# output module.dynamodb.contract_templates_table_name
output "contract_templates_table_name" {
    value = aws_dynamodb_table.contract_templates.name
}
