resource "aws_cloudwatch_log_metric_filter" "users_service_errors" {
  name           = "UsersServiceErrorFilter"
  log_group_name = "users-service-logs"
  pattern        = "ERROR"

  metric_transformation {
    name      = "UsersServiceErrors"
    namespace = "Selena"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "users_service_errors_alarm" {
  alarm_name          = "UsersServiceErrorsAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.users_service_errors.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.users_service_errors.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_actions       = [aws_sns_topic.alerts.arn] # сюда вставь свой SNS топик
}
