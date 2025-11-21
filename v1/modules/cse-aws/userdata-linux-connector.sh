#!/bin/bash
wget -O connector.tar.gz https://www.banyanops.com/netting/connector-${connector_version}.tar.gz
tar zxf connector.tar.gz
cd connector-${connector_version}/

echo 'command_center_url: ${cse_env}
api_key_secret: ${api_key_secret}
connector_name: ${connector_name}' > connector-config.yaml

sudo ./setup-connector.sh

