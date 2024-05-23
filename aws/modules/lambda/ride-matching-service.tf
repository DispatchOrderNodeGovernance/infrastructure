data "archive_file" "ride_matching_server" {
  type        = "zip"
  output_path = "${path.module}/ride_matching_service.zip"

  source {
    content  = data.http.ride_matching_service.response_body
    filename = "ride_matching_service.py"
  }
}
resource "aws_lambda_function" "ride_matching_service" {
  architectures = ["arm64"]
  function_name = "ride_matching_service_${var.environment}"
  filename      = data.archive_file.ride_matching_server.output_path
  # use hash of the file to trigger an update
  source_code_hash = data.archive_file.ride_matching_server.output_base64sha256

  handler = "ride_matching_service.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      RIDE_MATCHING_SERVICE_ENDPOINTS = var.ride_matching_service_endpoints
    }
  }

  role = aws_iam_role.lambda_exec.arn
}
