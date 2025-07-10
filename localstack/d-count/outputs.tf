output "bucket_names" {
  value = [for b in aws_s3_bucket.demo_buckets : b.bucket]
  description = "Names of the S3 buckets created"
}

