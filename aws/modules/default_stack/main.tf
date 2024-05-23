resource "aws_dynamodb_table_item" "default_stack" {
  table_name = var.contract_templates_table_name
  hash_key   = "id"

  item = <<ITEM
{
  "id": {"N": "2"},
  "ride_matching_service_endpoints": {"S": "${var.ride_matching_service_endpoints}"},
  "location_service_endpoints": {"S": "${var.location_service_endpoints}"},
  "notification_service_endpoints": {"S": "${var.notification_service_endpoints}"},
  "trip_management_service_endpoints": {"S": "${var.trip_management_service_endpoints}"},
  "ride_matching_service_contract_value": {"N": "0"},
  "location_service_contract_value": {"N": "0"},
  "notification_service_contract_value": {"N": "0"},
  "trip_management_service_contract_value": {"N": "0"},
  "beneficiary_id": {"N": "2"},
  "total_contract_value": {"N": "0"}
}
ITEM
}
