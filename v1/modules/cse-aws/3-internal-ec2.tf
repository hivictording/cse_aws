resource "aws_instance" "interal_server" {
  for_each = var.private_subnet_list

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id              = each.value.id
  vpc_security_group_ids = [aws_security_group.internal_webserver_securitygroup.id]
  key_name               = "vding-keypair-1"

  user_data = templatefile("${path.module}/userdata-internal-apache.sh", {
    internal_server_name = "${var.internal_server_name}-${each.value.cidr_block}"
  })

  user_data_replace_on_change = true

  tags = {
    Name = "${var.internal_server_name}-${each.value.cidr_block}"
  }
}
