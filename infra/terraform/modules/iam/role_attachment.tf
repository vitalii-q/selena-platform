resource "aws_iam_user_policy_attachment" "attach_ec2_policy" {
  user       = var.user_name
  policy_arn = aws_iam_policy.ec2_stop_start_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ec2_s3_access" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "selena_ec2_cloudwatch_attach" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_metrics_policy.arn
}
