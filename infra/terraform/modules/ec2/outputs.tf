output "elastic_ip" {
  value = aws_eip.this.public_ip
}

output "amazon_linux_ami_id" {
  value = data.aws_ami.amazon_linux_2023.id
  description = "The ID of the latest Amazon Linux 2023 AMI"
}