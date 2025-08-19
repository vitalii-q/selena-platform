variable "ec2_instance_id" {
  description = "ID EC2 инстанции для CloudWatch Alarm"
  type        = string
}

variable "notification_email" {
  description = "Email для уведомлений CloudWatch Alarm"
  type        = string
}

variable "selena_ec2_instance_profile" {
  description = "IAM Instance Profile для EC2 с CloudWatch Agent"
  type        = string
}

variable "alerts_topic_arn" {
  description = "ARN of SNS topic for CloudWatch alarms"
  type        = string
}
