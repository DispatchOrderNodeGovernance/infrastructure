data "archive_file" "trip_manager" {
  type        = "zip"
  output_path = "${path.module}/trip_manager.zip"

  source {
    content  = data.http.trip_management_service.response_body
    filename = "trip_management_service.py"
  }
}
resource "aws_lambda_function" "trip_management_service" {
  architectures = ["arm64"]
  function_name = "trip_management_service_${var.environment}_${local.service_version_dash}"
  filename      = data.archive_file.trip_manager.output_path
  # use hash of the file to trigger an update
  source_code_hash = data.archive_file.trip_manager.output_base64sha256

  handler = "trip_manager.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      TRIP_MANAGEMENT_SERVICE_ENDPOINTS = var.trip_management_service_endpoints
    }
  }

  role = aws_iam_role.lambda_exec.arn
}
