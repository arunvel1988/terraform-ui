output "s3_bucket_id" {
  value = module.my_s3_bucket.bucket_id
}

output "ec2_instance_id" {
  value = module.my_ec2_instance.instance_id
}
