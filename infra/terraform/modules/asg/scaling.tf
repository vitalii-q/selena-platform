# Scale-Out policy (increase instances when CPU > 70%)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "selena-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

# Scale-In policy (decrease instances when CPU < 30%)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "selena-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

# Аларм для масштабирования ВВЕРХ, если CPU > 70%
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "CPUHighScaleOut"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

# Аларм для масштабирования ВНИЗ, если CPU < 30%
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "CPULowScaleIn"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Alarm when CPU drops below 30%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
