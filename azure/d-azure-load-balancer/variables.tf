variable "resource_group_name" {
  default = "rg-webserver"
}

variable "location" {
  default = "East US"
}

variable "vnet_name" {
  default = "vnet-web"
}

variable "subnet_name" {
  default = "subnet-web"
}

variable "nsg_name" {
  default = "nsg-web"
}

variable "pip_name" {
  default = "pip-web"
}

variable "nic_name" {
  default = "nic-web"
}

variable "vm_name" {
  default = "vm-web"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "lb_name" {
  default = "lb-web"
}
