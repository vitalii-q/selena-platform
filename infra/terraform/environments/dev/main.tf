provider "aws" {
  region = "eu-central-1"
  profile = "default"
}

module "vpc" {
  source = "../../modules/vpc"
  # здесь параметры для модуля VPC
}

module "s3" {
  source = "../../modules/s3"
  # параметры для модуля S3
}