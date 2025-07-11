variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "Region for GCP resources"
}

variable "gcp_zone" {
  type        = string
  default     = "us-central1-a"
  description = "Zone for the instance"
}

variable "instance_name" {
  type        = string
  default     = "gcp-instance"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
}

variable "network_name" {
  type        = string
  default     = "default"
}

variable "subnet_name" {
  type        = string
  default     = "default"
}

variable "environment" {
  type        = string
  default     = "dev"
}
