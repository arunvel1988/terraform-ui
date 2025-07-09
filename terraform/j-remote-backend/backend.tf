terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "docker/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://localhost:9990"
    access_key                  = "minioadmin"
    secret_key                  = "minioadmin"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true   # 👈 REQUIRED to avoid AWS check
    force_path_style            = true
  }
}
