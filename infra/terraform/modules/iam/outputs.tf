output "ec2_s3_access_profile_name" {
  value = aws_iam_instance_profile.ec2_s3_access_profile.name
}

output "selena_ec2_profile_name" {
  value = aws_iam_instance_profile.selena_ec2_instance_profile.name
}

output "cloudwatch_agent_profile_name" {
  value = aws_iam_instance_profile.selena_ec2_instance_profile.name
}

output "selena_ec2_role_name" {
  value = aws_iam_role.selena_ec2_role.name
}
