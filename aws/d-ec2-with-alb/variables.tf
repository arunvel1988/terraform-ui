variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Your AWS EC2 key pair name"
  type        = string
}

variable "instance_name" {
  default = "terraform-alb-ec2"
}

variable "subnet_id" {
  description = "Single subnet for EC2"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC where resources will be deployed"
  type        = string
}
