#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
echo "Terraform-powered EC2 is running" > /var/www/html/index.html
