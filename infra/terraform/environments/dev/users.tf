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
  password               = data.aws_ssm_parameter.db_password.value
  port                   = 5432
  publicly_accessible    = true
  
  vpc_security_group_ids = [module.vpc.default_security_group_id, module.ec2.users_sg_id]

  db_subnet_group_name   = module.vpc.db_subnet_group
  env                    = var.env

  users_sg_id            = module.ec2.users_sg_id
  vpc_id                 = module.vpc.vpc_id
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

  alerts_topic_arn = module.sns.alerts_topic_arn
}

module "sns" {
  source      = "../../modules/sns"
  alert_email = "vitaly2822@gmail.com"
}

module "asg" {
  source = "../../modules/asg"

  environment          = "dev"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = [module.vpc.public_subnet_id]               # сейчас в публичном сабнете для простоты
  iam_instance_profile = module.iam.cloudwatch_agent_profile_name
}

data "aws_ssm_parameter" "db_password" {
  name = "/selena/dev/users-db-password"
}

# Разрешаем доступ к RDS от security group контейнера users-service
resource "aws_security_group_rule" "allow_users_service_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  # security_group_id        = module.users_rds.security_group_id
  security_group_id        = module.users_rds.rds_sg_id
  cidr_blocks              = ["10.0.1.0/24"]
  # source_security_group_id = module.ec2.users_sg_id
  description              = "Allow users-service to connect to RDS"
}

