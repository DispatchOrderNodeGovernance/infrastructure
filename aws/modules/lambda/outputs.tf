output "get_contract_templates_lambda_arn" {
  value = aws_lambda_function.get_contract_templates.arn
}

output "update_location_lambda_arn" {
  value = aws_lambda_function.update_location.arn
}

output "dispatch_lambda_arn" {
  value = aws_lambda_function.dispatch.arn
}
output "ride_matching_service_lambda_arn" {
  value = aws_lambda_function.ride_matching_service.arn
}
output "notification_server_lambda_arn" {
  value = aws_lambda_function.notification_server.arn
}
output "trip_management_service_lambda_arn" {
  value = aws_lambda_function.trip_management_service.arn
}
