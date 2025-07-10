variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name (must exist in AWS)"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name tag"
  default     = "MyTerraformEC2"
}

variable "environment" {
  description = "Tag for the environment"
  default     = "dev"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}
