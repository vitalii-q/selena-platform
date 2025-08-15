# Файл: infra/terraform/environments/dev/cloudwatch_cpu_alarm.tf [правка]

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "EC2HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 минут
  statistic           = "Average"
  threshold           = 80   # 80%
  alarm_description   = "Аларм срабатывает, если CPU > 80% в течение 5 минут"
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn] # SNS топик для уведомлений
  ok_actions          = [aws_sns_topic.cloudwatch_alerts.arn] # SNS топик при восстановлении
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

# SNS topic для уведомлений
resource "aws_sns_topic" "cloudwatch_alerts" {
  name = "cloudwatch-alerts"
}

# Подписка на e-mail (замени на свой)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = "your_email@example.com"
}
