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
  environment {
    variables = {
      LOCATION_SERVICE_ENDPOINTS = var.location_service_endpoints
    }
  }

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
