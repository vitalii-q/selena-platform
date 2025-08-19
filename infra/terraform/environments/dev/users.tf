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
  iam_instance_profile        = module.iam.cloudwatch_agent_profile_name
  selena_ec2_instance_profile = module.iam.selena_ec2_profile_name
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

module "users_service_s3" {
  source      = "../../modules/s3"
  bucket_name = "selena-users-service-env-${var.environment}"
  tags = {
    Name = "users-service-env"
    Environment = var.environment
  }
}

module "iam" {
  source = "../../modules/iam"
  user_name = "terraform-user"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  ec2_instance_id             = module.ec2.instance_id
  notification_email          = var.alert_email
  selena_ec2_instance_profile = module.iam.cloudwatch_agent_profile_name
}

module "sns" {
  source      = "../../modules/sns"
  alert_email = "vitaly@example.com"
}