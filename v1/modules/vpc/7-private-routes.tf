resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
      Name = "${var.vpc_name}-private-route-table"
    }
}


resource "aws_route_table_association" "private_subnet" {
    for_each = toset(var.private_subnet_index_list)

    subnet_id = values(aws_subnet.private_subnet_list)[each.value - 2].id
    route_table_id = aws_route_table.private.id
}
