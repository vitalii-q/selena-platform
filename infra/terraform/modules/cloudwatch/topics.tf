# SNS topic для уведомлений
resource "aws_sns_topic" "cloudwatch_alerts" {
  name = "cloudwatch-alerts"
}

# Подписка на e-mail
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
