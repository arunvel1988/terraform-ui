# ✅ Outputs a real S3 bucket URL
output "bucket_url" {
  value = "https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.real_bucket.bucket}"
}
