locals {
  connectors_subnet = cidrsubnet(var.cidr_block, 8, 0)
  access_tier_subnet = cidrsubnet(var.cidr_block, 8, 1)
}

resource "aws_subnet" "connectors" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.connectors_subnet
    availability_zone = var.availability_zone

    map_public_ip_on_launch = true

    tags = {
      Name = "${var.vpc_name}-connectors-${local.connectors_subnet}"
    }
}

resource "aws_subnet" "access-tiers" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.access_tier_subnet
    availability_zone = var.availability_zone

    map_public_ip_on_launch = true

    tags = {
      Name = "${var.vpc_name}-access-tiers-${local.access_tier_subnet}"
    }
}