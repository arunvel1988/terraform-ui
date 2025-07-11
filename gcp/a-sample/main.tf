terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "local" {} # Use local state for learning/dev
}

# export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account.json"
# gcloud auth application-default login


# GCP provider setup
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone

  # Authentication uses GOOGLE_APPLICATION_CREDENTIALS env variable:
  # export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
}
