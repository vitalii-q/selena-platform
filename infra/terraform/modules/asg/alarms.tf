# Scale-Out alarm (triggers when average CPU > 70%)
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "selena-asg-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Scale out when CPU > 70%"
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}

# Scale-In alarm (triggers when average CPU < 30%)
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "selena-asg-scale-in"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale in when CPU < 30%"
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
}
