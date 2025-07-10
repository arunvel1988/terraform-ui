terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # This backend stores Terraform state locally (for learning/dev)
  backend "local" {}
}


# export AWS_ACCESS_KEY_ID=your-access-key
# export AWS_SECRET_ACCESS_KEY=your-secret-key

# or

# export AWS_PROFILE=your-aws-cli-profile-name



# ✅ AWS provider setup for REAL AWS, not LocalStack
provider "aws" {
  region = var.aws_region

  # These credentials will be read from environment variables:
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
}
