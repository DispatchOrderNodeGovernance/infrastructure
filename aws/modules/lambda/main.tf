variable "environment" {

}
variable "dynamodb_table_contract_templates_arn" {

}
variable "dynamodb_table_contract_templates_name" {

}
variable "service_version" {
  default = "v0.3.9"
}
locals {
  service_version_dash = replace(var.service_version, ".", "-")

}
data "http" "dispatch" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/star-service/${var.service_version}/src/dispatch.py"
}
data "http" "update_location" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/location-service/${var.service_version}/src/update_location.py"
}
data "http" "get_contract_templates" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/complex/${var.service_version}/src/get_contract_templates.py"
}
data "http" "ride_matching_service" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/ride-matching-service/${var.service_version}/src/web-server.py"
}
data "http" "notification_server" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/notification-service/${var.service_version}/src/notification-server.py"
}
data "http" "trip_management_service" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/trip-management-service/${var.service_version}/src/trip-manager.py"
}
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}
resource "aws_iam_policy" "lambda_exec" {
  name        = "lambda_exec_${var.environment}"
  description = "Allow lambda to execute"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:GetItem",
        ]
        Resource = var.dynamodb_table_contract_templates_arn
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_exec.arn
}
