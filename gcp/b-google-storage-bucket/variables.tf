variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "Region where resources will be deployed"
  type        = string
  default     = "US"
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}
