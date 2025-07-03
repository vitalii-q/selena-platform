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

module "s3" {
  source = "../../modules/s3"
  # параметры для модуля S3
}