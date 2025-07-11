terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "local" {}
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
}

resource "google_storage_bucket" "example" {
  name     = var.bucket_name
  location = var.gcp_region
  force_destroy = true

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = null  # Use Google-managed keys by default
  }

  uniform_bucket_level_access = true

  labels = {
    Name        = "Example GCS Bucket"
    Environment = "Dev"
  }
}
