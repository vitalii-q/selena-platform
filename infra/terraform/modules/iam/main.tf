variable "user_name" {
  type = string
}

resource "aws_iam_policy" "ec2_stop_start_policy" {
  name        = "Ec2StopStartPolicy"
  description = "Policy to allow stopping and starting EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StopInstances",
          "ec2:StartInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_ec2_policy" {
  user       = var.user_name
  policy_arn = aws_iam_policy.ec2_stop_start_policy.arn
}
