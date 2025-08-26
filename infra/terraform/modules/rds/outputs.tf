output "endpoint" {
  value = aws_db_instance.users_postgres.endpoint
}

output "security_group_id" {
  value = aws_security_group.rds_sg.id
}
