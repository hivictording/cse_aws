module "cse_vpc" {
  source = "../modules/vpc"

  private_subnet_index_list = range(2, 5)
}
