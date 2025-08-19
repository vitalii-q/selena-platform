# CloudWatch Alarm для CPU
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "CPUHighAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm if CPU > 80%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions          = [aws_sns_topic.cloudwatch_alerts.arn]

  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}
