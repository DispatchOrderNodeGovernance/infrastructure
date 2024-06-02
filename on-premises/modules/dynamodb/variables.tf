
variable "contract_templates_table_name" {
    type = string
}
variable "read_capacity" {
    type = number
    default = 1
}
variable "write_capacity" {
    type = number
    default = 2
}
