resource "aws_db_instance" "users_postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "15.13"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  port                    = var.port
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = var.db_subnet_group_name
  skip_final_snapshot     = true

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade", "audit", "error", "general"]

  tags = {
    Name = var.db_identifier
    Env  = var.env
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "users-db-sg"
  description = "Security group for Users Service RDS"
  vpc_id      = var.vpc_id

  # Разрешим подключение по Postgres только от SG users-service
  ingress {
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    security_groups          = [var.users_sg_id]
    description              = "Allow Postgres from Users Service EC2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "db_password" {
  name = "/selena/dev/users-db-password"
}

resource "aws_cloudwatch_log_group" "users_db_logs" {
  name              = "/aws/rds/users-db-dev"
  retention_in_days = 14
}

