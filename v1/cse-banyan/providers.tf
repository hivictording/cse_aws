provider "banyan" {
  api_key = "WUravTGSdX9Wo_hLwI-06ly2jSKysLdYslOS02geHyc"
  host = "https://release.bnntest.com/"
}

terraform {
  required_version = ">=1.12.0"

  required_providers {
    banyan = {
      source = "banyansecurity/banyan"
      version = "1.2.15"
    }
  }
}