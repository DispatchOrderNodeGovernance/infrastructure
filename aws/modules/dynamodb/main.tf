/**
{
    "id": 1,
    "services": {
        "ride_matching_service": {
            "endpoints": "http://ride-matching-service.com",
            "timeout": 100,
            "contract_value": 20.00
        },
        "location_service": {
            "endpoints": "http://location-service.com",
            "timeout": 100,
            "contract_value": 20.00
        },
        "notification_service": {
            "endpoints": "http://notification-service.com",
            "timeout": 100,
            "contract_value": 20.00
        },
        "trip_management_service": {
            "endpoints": "http://trip-management-service.com",
            "timeout": 100,
            "contract_value": 20.00
        }
    },
    total_contract_value: 100.00,
    beneficiary_id: 1
}
*/
/* Free Tier
ALWAYS FREE
Amazon DynamoDB
25 GB
of storage
Serverless, NoSQL, fully managed database with single-digit millisecond performance at any scale.

25 GB of Storage
25 provisioned Write Capacity Units (WCU)
25 provisioned Read Capacity Units (RCU)
Enough to handle up to 200M requests per month. */

# main.tf will contain the main set of configuration for your module. You can also create other configuration files and organize them however makes sense for your project.

resource "aws_dynamodb_table" "contract_templates" {
    name           = var.contract_templates_table_name
    billing_mode   = "PAY_PER_REQUEST"
//    read_capacity  = var.read_capacity
//    write_capacity = var.write_capacity
    hash_key       = "id"
    # range_key is optional, this used for purpose of sorting
    # partition_key is used for partitioning the data
    # range_key      = "beneficiary_id"
    attribute {
        name = "id"
        type = "N"
    }
/*  
    attribute {
        name = "ride_matching_service_endpoints"
        type = "S"
    }
    attribute {
        name = "ride_matching_service_timeout"
        type = "N"
    }
    attribute {
        name = "ride_matching_service_contract_value"
        type = "N"
    }
    attribute {
        name = "location_service_endpoints"
        type = "S"
    }
    attribute {
        name = "location_service_timeout"
        type = "N"
    } 
    attribute {
        name = "location_service_contract_value"
        type = "N"
    }
    attribute {
        name = "notification_service_endpoints"
        type = "S"
    }
    attribute {
        name = "notification_service_timeout"
        type = "N"
    }
    attribute {
        name = "notification_service_contract_value"
        type = "N"
    }
    attribute {
        name = "trip_management_service_endpoints"
        type = "S"
    }
    attribute {
        name = "trip_management_service_timeout"
        type = "N"
    }
    attribute {
        name = "trip_management_service_contract_value"
        type = "N"
    } */
    global_secondary_index {
        name = "total_contract_value_index"
        hash_key = "total_contract_value"
        projection_type = "ALL"
    }

    attribute {
        name = "total_contract_value"
        type = "N"
    }
}
