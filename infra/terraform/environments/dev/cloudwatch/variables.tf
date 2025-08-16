variable "ec2_instance_id" {
  description = "ID EC2 инстанции для CloudWatch Alarm"
  type        = string
}

variable "notification_email" {
  description = "Email для уведомлений CloudWatch Alarm"
  type        = string
}

variable "selena_ec2_instance_profile" {
  default = aws_iam_instance_profile.cloudwatch_agent_profile.name
}