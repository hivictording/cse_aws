variable "availability_zone" {
  type        = string
  description = "availability zone"
  default     = "us-east-2a"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "cse-main"
}

variable "cidr_block" {
  type        = string
  description = "vpc cidr block"
  default     = "172.28.0.0/16"
}

# variable "connector_cidr_block" {
#   type        = string
#   description = "cidr block for cse connectors"
#   default     = "172.28.0.0/24"
# }

# variable "access_tier_cidr_block" {
#   type        = string
#   description = "cidr block for cse access tiers"
#   default     = "172.28.1.0/24"
# }

# variable "private_subnet_cidr_block" {
#   type        = string
#   description = "cidr block for private subnet"
#   default     = "172.28.2.0/24"
# }

variable "private_subnet_index_list" {
  type        = list(string)
  description = "private subnet index list"
}

