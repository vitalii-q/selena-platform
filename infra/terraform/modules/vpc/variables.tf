variable "project" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "availability_zone" {}

variable "availability_zone_2" {
  description = "Second availability zone for private subnet"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for second private subnet"
  type        = string
}