variable "aws_region" {
  description = "AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "Mock AWS Access Key for LocalStack"
  type        = string
  default     = "mock_access_key"
}

variable "secret_key" {
  description = "Mock AWS Secret Key for LocalStack"
  type        = string
  default     = "mock_secret_key"
}

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "visibility_timeout" {
  description = "Visibility timeout in seconds"
  type        = number
  default     = 30
}
