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


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {}
}

provider "aws" {
  region = "ap-south-1"
}

# ✅ Data source: Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ✅ Security group to allow SSH
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 🔒 Restrict in real environments
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ✅ EC2 instance with all major options
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = file("bootstrap.sh")  # Optional startup script

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}



