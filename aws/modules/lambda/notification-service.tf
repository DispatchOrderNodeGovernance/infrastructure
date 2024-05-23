data "archive_file" "notification_server" {
  type        = "zip"
  output_path = "${path.module}/notification_server.zip"

  source {
    content  = data.http.notification_server.response_body
    filename = "notification_server.py"
  }
}
resource "aws_lambda_function" "notification_server" {
  architectures = ["arm64"]
  function_name = "notification_server_${var.environment}"
  filename      = data.archive_file.notification_server.output_path
  # use hash of the file to trigger an update
  source_code_hash = data.archive_file.notification_server.output_base64sha256

  handler = "notification_server.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      NOTIFICATION_SERVICE_ENDPOINTS = var.notification_service_endpoints
    }
  }

  role = aws_iam_role.lambda_exec.arn
}
