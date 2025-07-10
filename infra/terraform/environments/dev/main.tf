# infra/terraform/environments/dev/main.tf

provider "aws" {
  region = "eu-central-1"
  profile = "terraform"
}

