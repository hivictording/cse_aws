resource "aws_security_group" "cse_connector_securitygroup" {
  name = "cse_connector_securitygroup"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  vpc_id = var.vpc_id

  tags = {
    Name = "cse_connector_securitygroup"
  }
}

resource "aws_security_group" "internal_webserver_securitygroup" {
  name = "internal_webserver_securitygroup"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  vpc_id = var.vpc_id

  tags = {
    Name = "internal_webserver_securitygroup"
  }
}

