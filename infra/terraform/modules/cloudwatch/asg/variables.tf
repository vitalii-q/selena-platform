variable "ami_id"               { type = string }
variable "instance_type"        { type = string }
variable "key_name"             { type = string }
variable "vpc_id"               { type = string }
variable "subnet_ids"           { type = list(string) } # в каких сабнетах крутить ASG
variable "iam_instance_profile" { type = string }       # имя Instance Profile (CloudWatchAgent и т.п.)

