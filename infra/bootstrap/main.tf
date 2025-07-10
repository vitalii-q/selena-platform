provider "aws" {
  region = "eu-central-1"
  profile = "default"
}

resource "aws_iam_policy" "terraform_admin_policy" {
  name        = "TerraformFullAccessPolicy"
  description = "Policy for Terraform to fully manage AWS infrastructure"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.terraform_admin_policy.arn
}

resource "aws_iam_access_key" "terraform_access_key" {
  user = aws_iam_user.terraform_user.name
}

output "access_key_id" {
  value = aws_iam_access_key.terraform_access_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.terraform_access_key.secret
  sensitive = true
}
