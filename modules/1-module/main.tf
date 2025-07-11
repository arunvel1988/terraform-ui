provider "aws" {
  region = "ap-south-1"
}

module "my_s3_bucket" {
  source      = "./../s3"
  bucket_name = "my-unique-bucket-name-2025"
}

module "my_ec2_instance" {
  source        = "./../ec2"
  ami           = "ami-0c55b159cbfafe1f0" # replace with a valid AMI
  instance_type = "t2.micro"
  name          = "my-ec2-instance"
}
