variable "aws_region" {
  description = "AWS region to use (mocked)"
  default     = "us-east-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket names"
  default     = "teaching-demo-bucket"
}

variable "bucket_count" {
  description = "Number of S3 buckets to create"
  default     = 2
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  default     = "teaching-demo-table"
}
