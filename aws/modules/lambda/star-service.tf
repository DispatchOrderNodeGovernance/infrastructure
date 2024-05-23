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
    })
  })
}
resource "local_file" "dispatch" {
  content = <<EOF
${jsondecode(aws_lambda_invocation.dispatch.result).body}
${jsondecode(aws_lambda_invocation.dispatch.input).body}
EOF
  filename = "dispatch_result.ndjson"
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
      DISPATCH_ENDPOINT = var.dispatch_endpoint
      CONTRACT_TEMPLATES_TABLE_NAME = var.dynamodb_table_contract_templates_name
    }
  }

  role = aws_iam_role.lambda_exec.arn
}
