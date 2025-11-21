resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
      Name = "${var.vpc_name}-default-route-table"
    }
}

resource "aws_route_table_association" "connectors" {
    subnet_id = aws_subnet.connectors.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "access_tiers" {
    subnet_id = aws_subnet.access-tiers.id
    route_table_id = aws_route_table.public.id
}