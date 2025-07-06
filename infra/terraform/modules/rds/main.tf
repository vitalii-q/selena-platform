resource "aws_db_instance" "users_postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "15.3"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  port                    = var.port
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = var.db_subnet_group_name
  skip_final_snapshot     = true

  tags = {
    Name = var.db_identifier
    Env  = var.env
  }
}
