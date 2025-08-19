output "alerts_topic_arn" {
  value = aws_sns_topic.alerts.arn
  description = "ARN of the SNS topic for alerts"
}