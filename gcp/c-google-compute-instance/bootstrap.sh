#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
echo "<h1>Hello from GCP</h1>" > /var/www/html/index.html
sudo systemctl enable nginx
sudo systemctl restart nginx