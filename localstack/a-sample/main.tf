terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {}  # Optional, stores state locally
}


provider "aws" {
  region                      = "us-east-1"
  access_key                 = "mock_access_key"
  secret_key                 = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true        # <--- This is critical
  s3_use_path_style           = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-localstack-bucket"
}

output "bucket_url" {
  value = "http://localhost:4566/${aws_s3_bucket.test_bucket.bucket}"
}
