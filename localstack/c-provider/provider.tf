terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


 backend "local" {
    path = "./terraform.tfstate"
  }
}