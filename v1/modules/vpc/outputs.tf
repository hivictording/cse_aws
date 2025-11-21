output "vpc" {
  value = aws_vpc.main
}

output "connector_subnet" {
  value = aws_subnet.connectors
}

output "access_tier_subnet" {
  value = aws_subnet.access-tiers
}

output "private_subnet_list" {

  # value = [ for subnet in aws_subnet.private_subnet_list : [subnet.id,subnet.cidr_block]]
  # value = {
  #   id = values(aws_subnet.private_subnet_list)[*].id,
  #   cidr_block = values(aws_subnet.private_subnet_list)[*].cidr_block,
  # }

  value = aws_subnet.private_subnet_list
  
}

