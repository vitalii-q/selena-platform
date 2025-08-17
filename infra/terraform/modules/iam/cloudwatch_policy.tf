resource "aws_iam_policy" "cloudwatch_metrics_policy" {
  name        = "SelenaEC2CloudWatchMetricsPolicy"
  description = "Allow EC2 instances to send and list CloudWatch metrics"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics"
        ]
        Resource = "*"
      }
    ]
  })
}
