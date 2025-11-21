module "cse_aws" {
  source = "../modules/cse-aws"

  vpc_id = data.terraform_remote_state.vpc.outputs.cse_vpc.id
#   subnet_id = data.terraform_remote_state.vpc.outputs.connector_subnet.id
  private_subnet_list = data.terraform_remote_state.vpc.outputs.private_subnet_list
#   private_subnet_list = {for key,value in data.terraform_remote_state.vpc.outputs.private_subnet_list : value.id => value.cidr_block}


  ami = var.ami
  instance_type = var.instance_type
  connector_version = var.connector_version
  cse_env = var.cse_env
  api_key_secret = var.api_key_secret
  connector_name = var.connector_name
  
#   private_subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet.id
  internal_server_name = var.internal_server_name
}