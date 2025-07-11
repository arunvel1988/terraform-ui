#dos2unix bootstrap.sh
#chmod +x bootstrap.sh

#!/bin/bash
apt update -y
apt install -y apache2
systemctl start apache2
echo "Hello from Azure Terraform Apache VM" > /var/www/html/index.html
