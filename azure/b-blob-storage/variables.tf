variable "resource_group_name" {
  type    = string
  default = "terraform-rg"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "storage_account_name" {
  type    = string
  default = "tfexamplestorage123"  # must be globally unique and lowercase
}

variable "container_name" {
  type    = string
  default = "example-container"
}
