output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "default_security_group_id" {
  value = aws_vpc.main.default_security_group_id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.main.name
}