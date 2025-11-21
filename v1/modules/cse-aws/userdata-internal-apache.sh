#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
echo "CSE Web Server ${internal_server_name}" | sudo tee /var/www/html/index.html
