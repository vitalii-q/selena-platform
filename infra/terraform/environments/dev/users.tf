module "vpc" {
  source              = "../../modules/vpc"

  project             = "selena"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "eu-central-1a"

  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone_2   = var.availability_zone_2
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id        = "ami-0381f7486a6b24f34"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent_instance_profile.name
}

module "s3" {
  source = "../../modules/s3"
  # параметры для модуля S3
}

module "users_rds" {
  source = "../../modules/rds"

  db_identifier          = "users-db-${var.env}"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "users_db"
  username               = "postgres"
  password               = "postgres"
  port                   = 5432
  publicly_accessible    = true
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  db_subnet_group_name   = module.vpc.db_subnet_group
  env                    = var.env
}
