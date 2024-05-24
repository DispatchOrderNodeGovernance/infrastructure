data "archive_file" "dispatch" {
  type        = "zip"
  output_path = "${path.module}/dispatch.zip"

  source {
    content  = data.http.dispatch.response_body
    filename = "dispatch.py"
  }
}
resource "aws_lambda_invocation" "dispatch" {
  function_name = aws_lambda_function.dispatch.function_name
  depends_on    = [aws_lambda_function.dispatch]

  input = jsonencode({
    body: jsonencode({
      no_cache: timestamp(),
      action: "dispatch",
      stack_id: 2,
      uuid: "value_${random_id.driver_id.hex}",
    })
  })
}
resource "aws_lambda_invocation" "quote" {
  function_name = aws_lambda_function.dispatch.function_name
  depends_on    = [aws_lambda_function.dispatch, aws_lambda_invocation.dispatch]

  input = jsonencode({
    body: jsonencode({
      action: "quote",
      uuid: "value_${random_id.driver_id.hex}",
      token: "value_${random_id.driver_id.hex}",
      contract_uuid: "value_${random_id.driver_id.hex}",
      contract_value: 100,
      location_service_endpoints: var.location_service_endpoints
    })
  })
}
resource "local_file" "dispatch" {
  content = jsondecode(aws_lambda_invocation.dispatch.result).body
  filename = "dispatch_result.json"
}
resource "aws_lambda_function" "dispatch" {
  architectures    = ["arm64"]
  function_name    = "dispatch_${var.environment}"
  filename         = data.archive_file.dispatch.output_path
  source_code_hash = data.archive_file.dispatch.output_base64sha256

  handler = "dispatch.lambda_handler"
  runtime = "python3.8"
  timeout = 10

  environment {
    variables = {
      DISPATCH_ENDPOINT = var.dispatch_endpoint
      CONTRACT_TEMPLATES_TABLE_NAME = var.dynamodb_table_contract_templates_name
    }
  }

  role = aws_iam_role.lambda_exec.arn
}
