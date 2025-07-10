output "bucket_url" {
  value = "https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.example.bucket}"
}