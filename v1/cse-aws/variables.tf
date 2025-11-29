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
  default = "2.0.7"
}

variable "cse_env" {
  type = string
  description = "cse environment"
  default = "https://release.bnntest.com"
}

variable "api_key_secret" {
  type = string
  description = "api_key_secret for connector installation"
  default = "CqyXdUWfabPgBtUme07gENR64dkDPhv1c46uEVYoCdk"
}

variable "connector_name" {
  type = string
  description = "connector name"
  default = "myconnector"
}

variable "internal_server_name" {
  type = string
  description = "internal server name"
  default = "interal_linux_webserver"
}
