


# pip install awscli-local
# awslocal sqs list-queues
# awslocal sqs list-queues --region us-east-1


provider "aws" {
  region                      = var.aws_region
  access_key                  = var.access_key
  secret_key                  = var.secret_key
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    sqs = "http://localhost:4566"
  }
}



resource "aws_sqs_queue" "demo_queue" {
  name                      = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout
}
