
# awslocal s3 ls
# awslocal dynamodb list-tables



provider "aws" {
  region                      = var.aws_region
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
  }
}

# ✅ Data Source: caller identity (mocked in LocalStack)
#data "aws_caller_identity" "current" {}

# ✅ Create multiple S3 buckets using count
resource "aws_s3_bucket" "demo_buckets" {
  count = var.bucket_count

  bucket = "${var.bucket_name_prefix}-${count.index}"
  force_destroy = true
}

# ✅ Create a DynamoDB Table
resource "aws_dynamodb_table" "demo_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Purpose     = "test"
  }
}
