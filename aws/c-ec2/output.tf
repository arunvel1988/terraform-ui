output "instance_id" {
  value       = aws_instance.ec2.id
  description = "EC2 instance ID"
}

output "public_ip" {
  value       = aws_instance.ec2.public_ip
  description = "Public IP of the instance"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.ec2.public_ip}"
  description = "SSH command to access the instance"
}

output "ami_used" {
  value       = data.aws_ami.amazon_linux.id
  description = "AMI used for the instance"
}
