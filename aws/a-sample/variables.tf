variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-south-1" 
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
  default     = "terraform-real-bucket-12345" 
}
