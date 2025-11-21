variable "ami" {
  type = string
  description = "ami id"
#   default = "ami-0c803b171269e2d72"
  default = "ami-0d1b5a8c13042c939"
}

variable "instance_type" {
  type = string
  description = "instance_type"
  default = "t2.micro"
}

variable "connector_version" {
  type = string
  description = "connection version"
  default = "2.0.3"
}

variable "cse_env" {
  type = string
  description = "cse environment"
  default = "https://release.bnntest.com"
}

variable "api_key_secret" {
  type = string
  description = "api_key_secret for connector installation"
  default = "_GasX1O3e5zl0iHIr6tjScdX8-RMt6n18dKWrhOL3tA"
}

variable "connector_name" {
  type = string
  description = "connector name"
  default = "aws_linux_connector"
}

variable "internal_server_name" {
  type = string
  description = "internal server name"
  default = "interal_linux_webserver"
}
