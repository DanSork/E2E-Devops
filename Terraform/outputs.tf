output "instance_public_ip" {
  value = aws_instance.builder.public_ip
}

output "ssh_private_key_path" {
  value       = local_file.private_key.filename
  description = "Path to the generated private SSH key"
  sensitive   = true
}

output "ssh_key_name" {
  value       = aws_key_pair.builder_key.key_name
  description = "Name of the AWS SSH key pair"
}

output "security_group_id" {
  description = "id of sg for ec2"
  value       = aws_security_group.dan_sg.id
}