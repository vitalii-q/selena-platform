resource "aws_security_group" "asg_sg" {
  name        = "selena-asg-sg"
  description = "SG for ASG instances"
  vpc_id      = var.vpc_id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "selena-asg-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  # при желании сюда можно добавить user_data
}

resource "aws_autoscaling_group" "this" {
  name                      = "selena-asg"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # чтобы Terraform ждал, пока инстансы поднимутся
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "selena-asg-instance"
    propagate_at_launch = true
  }
}

# Target Tracking: держать среднюю CPU группы около 50%
resource "aws_autoscaling_policy" "cpu_tgt_tracking" {
  name                   = "cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}
