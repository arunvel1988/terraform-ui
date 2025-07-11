terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#  Bucket using AWS module
module "my_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "my-unique-bucket-name-2025" 
  acl    = "private"

  versioning = {
    enabled = true
  }

  tags = {
    Environment = "dev"
    Owner       = "arunvel"
  }
}

# Instance using AWS module
module "my_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "my-ec2-instance"

  ami           = "ami-0c55b159cbfafe1f0"  
  instance_type = "t2.micro"

  tags = {
    Environment = "dev"
    Owner       = "arun"
  }
}
