provider "aws" {
  region = "eu-central-1"
  profile = "default"
}

module "vpc" {
  source              = "../../modules/vpc"
  project             = "selena"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "eu-central-1a"
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id        = "ami-00c8ac9147e19828e"       # Amazon Linux 2023 kernel-6.1 AMI
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  key_name      = var.key_name
}

module "s3" {
  source = "../../modules/s3"
  # параметры для модуля S3
}