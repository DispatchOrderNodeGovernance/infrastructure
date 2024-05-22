output "get_contract_templates_lambda_arn" {
  value = aws_lambda_function.get_contract_templates.arn
}

output "update_location_lambda_arn" {
  value = aws_lambda_function.update_location.arn
}