# ✅ S3 bucket definition (will create an actual bucket on AWS)
resource "aws_s3_bucket" "real_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "dev"
    Project     = "terraform-on-aws"
  }
}
