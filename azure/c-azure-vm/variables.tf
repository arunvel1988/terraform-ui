variable "location" {
  default = "Central India"
}

variable "resource_group_name" {
  default = "vm-rg"
}

variable "vm_name" {
  default = "example-vm"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "environment" {
  default = "dev"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
