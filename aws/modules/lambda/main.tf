variable "environment" {

}
variable "dynamodb_table_contract_templates_arn" {
  
}
variable "dynamodb_table_contract_templates_name" {
  
}

# https://raw.githubusercontent.com/DispatchOrderNodeGovernance/complex/main/src/get_contract_templates.py

data "http" "get_contract_templates" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/complex/main/src/get_contract_templates.py"
}
data "archive_file" "contract_templates" {
  type        = "zip"
  output_path = "${path.module}/get_contract_templates.zip"
  source {
    content  = data.http.get_contract_templates.response_body
    filename = "get_contract_templates.py"
  }
}
resource "aws_lambda_function" "get_contract_templates" {
  function_name = "get_contract_templates_${var.environment}"
  filename      = data.archive_file.contract_templates.output_path

  handler = "get_contract_templates.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      CONTRACT_TEMPLATES_TABLE_NAME = var.dynamodb_table_contract_templates_name
    }
  }

  role = aws_iam_role.lambda_exec.arn
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
          "dynamodb:Scan",
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
