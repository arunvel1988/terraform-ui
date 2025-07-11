resource "google_storage_bucket" "gcs_bucket" {
  name     = var.bucket_name
  location = var.gcp_region
  force_destroy = true  # Optional: allows deletion even if not empty

  uniform_bucket_level_access = true  # Recommended security best practice

  labels = {
    environment = "dev"
    project     = "terraform-on-gcp"
  }
}
