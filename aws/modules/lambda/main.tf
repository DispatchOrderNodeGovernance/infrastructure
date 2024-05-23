variable "environment" {

}
variable "dynamodb_table_contract_templates_arn" {

}
variable "dynamodb_table_contract_templates_name" {

}

data "http" "dispatch" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/star-service/v0.1.2/src/dispatch.py"
}
data "archive_file" "dispatch" {
  type        = "zip"
  output_path = "${path.module}/dispatch.zip"

  source {
    content  = data.http.dispatch.response_body
    filename = "dispatch.py"
  }
}
resource "aws_lambda_function" "dispatch" {
  architectures    = ["arm64"]
  function_name    = "dispatch_${var.environment}"
  filename         = data.archive_file.dispatch.output_path
  source_code_hash = data.archive_file.dispatch.output_base64sha256

  handler = "dispatch.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      CONTRACT_TEMPLATES_TABLE_NAME = var.dynamodb_table_contract_templates_name
    }
  }

  role = aws_iam_role.lambda_exec.arn
}

data "http" "update_location" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/location-service/v0.1.2/src/update_location.py"
}
data "archive_file" "update_location" {
  type        = "zip"
  output_path = "${path.module}/update_location.zip"

  source {
    content  = data.http.update_location.response_body
    filename = "update_location.py"
  }
}
resource "aws_lambda_function" "update_location" {
  architectures    = ["arm64"]
  function_name    = "update_location_${var.environment}"
  filename         = data.archive_file.update_location.output_path
  source_code_hash = data.archive_file.update_location.output_base64sha256

  handler = "update_location.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_exec.arn
}
resource "random_id" "driver_id" {
  // always generate a new id
  keepers = {
    always_run = timestamp()
  }
  byte_length = 8
}
/* resource "aws_lambda_invocation" "update_location" {
  function_name = aws_lambda_function.update_location.function_name
  depends_on    = [aws_lambda_function.update_location]

  input = jsonencode({
    "longitude" : 105.84401565986708,
    "latitude" : 21.001407164932232,
    "driver_id" : "value_${random_id.driver_id.hex}",
    "status" : "in_trip"
  })
} */
/* resource "local_file" "update_location" {
  content  = aws_lambda_invocation.update_location.result
  filename = "update_location_result.json"
}
 */
data "http" "get_contract_templates" {
  url = "https://raw.githubusercontent.com/DispatchOrderNodeGovernance/complex/v1.0.1/src/get_contract_templates.py"
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
  architectures = ["arm64"]
  function_name = "get_contract_templates_${var.environment}"
  filename      = data.archive_file.contract_templates.output_path
  # use hash of the file to trigger an update
  source_code_hash = data.archive_file.contract_templates.output_base64sha256

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
