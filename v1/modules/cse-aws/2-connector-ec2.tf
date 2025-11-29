resource "aws_instance" "connector" {
  for_each = var.private_subnet_list

  ami                    = var.ami
  instance_type          = var.instance_type

  subnet_id = each.value.id
  vpc_security_group_ids = [aws_security_group.cse_connector_securitygroup.id]
  key_name = "vding-keypair-1"

  user_data = templatefile("${path.module}/userdata-linux-connector.sh", {
    connector_name = "${var.connector_name}-${split("/", each.value.cidr_block)[0]}",
    connector_version = var.connector_version,
    cse_env = var.cse_env
    api_key_secret = var.api_key_secret
  })

  user_data_replace_on_change = true

  tags = {
    Name = "${var.connector_name}-${each.value.cidr_block}"
  }
}
