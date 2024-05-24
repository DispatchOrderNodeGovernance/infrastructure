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
  function_name = "get_contract_templates_${var.environment}_${local.service_version_dash}"
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
