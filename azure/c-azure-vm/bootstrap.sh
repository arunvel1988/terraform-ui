

# base64 bootstrap.sh > encoded.txt  # only needed for direct file content inline
# This is the content of bootstrap.sh for setting up Nginx on an Azure VM
# The file is used to bootstrap the Nginx installation on an Azure VM instance.
#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
