resource "aws_cloudwatch_log_group" "users_service_logs" {
  name              = "users-service-logs"
  retention_in_days = 14

  tags = {
    Project = "Selena"
    Service = "users-service"
  }
}

resource "aws_iam_role" "cloudwatch_agent_server_role" {
  name = "CloudWatchAgentServerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  role       = aws_iam_role.cloudwatch_agent_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "CloudWatchAgentInstanceProfile"
  role = aws_iam_role.cloudwatch_agent_server_role.name
}
