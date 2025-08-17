resource "aws_iam_role_policy_attachment" "selena_ec2_cloudwatch_attach" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_metrics_policy.arn
}
