# Подвязываем managed-политику CloudWatch к нашей EC2 роли
resource "aws_iam_role_policy_attachment" "selena_ec2_cloudwatch" {
  role       = var.selena_ec2_role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
