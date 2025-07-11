variable "project_id" {}
variable "gcp_region" {
  default = "us-central1"
}
variable "gcp_zone" {
  default = "us-central1-a"
}
variable "instance_name" {
  default = "gcp-web-instance"
}
variable "instance_type" {
  default = "e2-medium"
}
variable "network" {
  default = "default"
}
variable "subnet" {
  default = "default"
}
