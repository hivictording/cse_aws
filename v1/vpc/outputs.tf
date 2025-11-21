output "cse_vpc" {
  value = module.cse_vpc.vpc
}

output "connector_subnet" {
  value = module.cse_vpc.connector_subnet
}

output "access_tier_subnet" {
  value = module.cse_vpc.access_tier_subnet
}

output "private_subnet_list" {
  value = module.cse_vpc.private_subnet_list
}
