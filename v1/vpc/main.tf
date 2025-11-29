module "cse_vpc" {
  source = "../modules/vpc"

  private_subnet_index_list = range(208, 211)
}
