variable "db_identifier" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "db_name" {}
variable "username" {}
variable "password" {}
variable "port" {}
variable "publicly_accessible" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "db_subnet_group_name" {}
variable "env" {}
