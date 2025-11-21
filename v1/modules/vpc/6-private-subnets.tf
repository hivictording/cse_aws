resource "aws_subnet" "private_subnet_list" {
    for_each = toset(var.private_subnet_index_list)

    vpc_id = aws_vpc.main.id
    # cidr_block = var.private_subnet_cidr_block
    cidr_block = cidrsubnet(var.cidr_block, 8, each.value)
    availability_zone = var.availability_zone

    tags = {
      Name = "${var.vpc_name}-private-subnet-${cidrsubnet(var.cidr_block, 8, each.value)}"
    }
}