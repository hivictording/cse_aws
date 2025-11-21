module "cse_banyan" {
    source = "../modules/cse-banyan"

    connector_name = "aws_linux_connector"
    connector_numbers = range(3, 5)
    cidr_block = "172.28.0.0/16"
}