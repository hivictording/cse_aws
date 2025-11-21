variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "private_subnet_list" {
  type = map(object({
    id=string,
    cidr_block=string
  }))
  description = "subnet id list"
}

variable "ami" {
  type        = string
  description = "ami id"
}

variable "instance_type" {
  type        = string
  description = "instance_type"
}

variable "connector_version" {
  type        = string
  description = "connection version"
}

variable "cse_env" {
  type        = string
  description = "cse environment"
}

variable "api_key_secret" {
  type        = string
  description = "api_key_secret for connector installation"
}

variable "connector_name" {
  type        = string
  description = "connector name"
}

variable "internal_server_name" {
  type        = string
  description = "internal server name"
}

