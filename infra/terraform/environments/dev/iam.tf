resource "aws_cloudwatch_log_group" "users_service_logs" {
  name              = "users-service-logs"
  retention_in_days = 14

  tags = {
    Project = "Selena"
    Service = "users-service"
  }
}

# Привязываем политику к роли
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  role       = aws_iam_role.cloudwatch_agent_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile для EC2
resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "CloudWatchAgentInstanceProfile"
  role = aws_iam_role.cloudwatch_agent_server_role.name
}

resource "aws_iam_role" "cloudwatch_agent_server_role" {
  name = "cloudwatch-agent-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

    tags = {
    Project = "Selena"
    Service = "users-service"
  }
}

# Создаём terraform-user
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
}

# Добавляем inline-политику, разрешающую создавать IAM ресурсы
resource "aws_iam_user_policy" "terraform_user_policy" {
  name = "terraform-user-policy"
  user = aws_iam_user.terraform_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:CreatePolicy",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:CreateRole",
          "iam:PassRole",
          "iam:CreateInstanceProfile",
          "iam:AddRoleToInstanceProfile"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*"
        ],
        Resource = "*"
      }
    ]
  })
}
