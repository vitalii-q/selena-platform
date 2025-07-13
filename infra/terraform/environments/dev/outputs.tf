output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "users_service_eip" {
  value = module.ec2.elastic_ip
}

output "amazon_linux_ami_id" {
  value       = module.ec2.amazon_linux_ami_id
  description = "The ID of the latest Amazon Linux 2023 AMI from the EC2 module"
}