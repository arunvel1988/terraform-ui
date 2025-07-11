variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}

variable "gcp_region" {
  description = "Region for GCS bucket (like US, EU, or asia-east1)"
  type        = string
  default     = "US"
}
