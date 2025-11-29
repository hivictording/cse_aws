resource "banyan_api_key" "connector_apikey" {
  name        = "connector_apikey"
  description = "api key for connector creation"
  scope       = "satellite"
}

resource "banyan_connector" "connectors" {
  # for_each = toset(var.connector_numbers)
  count = 3

  name       = "${var.connector_name}-${split("/", cidrsubnet(var.cidr_block, 8, count.index + 2))[0]}"
  # name       = "${var.connector_name}-${split("/", cidrsubnet(var.cidr_block, 8, each.value))[0]}"
  api_key_id = banyan_api_key.connector_apikey.id
  # cidrs      = [cidrsubnet(var.cidr_block, 8, each.value)]
  cidrs      = [cidrsubnet(var.cidr_block, 8, count.index + 2)]

  domains    = ["canadasolution.com"]
  extended_network_access = true
}
