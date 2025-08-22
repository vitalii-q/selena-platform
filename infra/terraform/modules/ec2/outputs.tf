output "elastic_ip" {
  value = aws_eip.this[0].public_ip
}

output "amazon_linux_ami_id" {
  value = data.aws_ami.amazon_linux_2023.id
  description = "The ID of the latest Amazon Linux 2023 AMI"
}

output "instance_id" {
  value = aws_instance.users_service[0].id
  description = "ID созданного EC2 экземпляра"
}

output "users_sg_id" {
  value = aws_security_group.users_sg.id
}
