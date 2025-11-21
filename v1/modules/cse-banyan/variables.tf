variable "connector_name" {
  type        = string
  description = "connector name"
}

variable "connector_numbers" {
  type        = list(string)
  description = "list of connector numbers"
}

variable "cidr_block" {
  type        = string
  description = "vpc cidr block"
}
