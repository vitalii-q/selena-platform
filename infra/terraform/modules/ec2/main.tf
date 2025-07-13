# -----------------------
# USERS-SERVICE
# -----------------------

resource "aws_instance" "users_service" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.users_sg.id]
  key_name      = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile

    user_data = <<-EOF
                #!/bin/bash

                # Лог в файл для отладки
                exec > /var/log/user-data.log 2>&1

                # Обновление системы
                yum update -y
                yum install -y openssh-server
                systemctl enable sshd
                systemctl start sshd

                # Установка Docker, если не установлен
                if ! command -v docker &> /dev/null; then
                  amazon-linux-extras enable docker
                  yum install -y docker
                  systemctl start docker
                  systemctl enable docker
                fi

                # Установка Git, если не установлен
                if ! command -v git &> /dev/null; then
                  yum install -y git
                fi

                # Добавить ec2-user в группу docker
                usermod -aG docker ec2-user

                # Клонируем репозиторий, если не существует
                if [ ! -d "/home/ec2-user/selena-users-service" ]; then
                  git clone https://github.com/vitalii-q/selena-users-service.git /home/ec2-user/selena-users-service
                fi

                cd /home/ec2-user/selena-users-service

                # Собираем образ (если ещё нет)
                if ! docker image inspect selena-users-service:latest > /dev/null 2>&1; then
                  docker build -t selena-users-service .
                fi

                # Останавливаем старый контейнер, если он есть
                if docker ps -a --format '{{.Names}}' | grep -q '^selena-users-service$'; then
                  docker stop selena-users-service
                  docker rm selena-users-service
                fi

                # Запускаем контейнер
                docker run -d \
                --name selena-users-service \
                --env-file .env \
                -p 9065:9065 \
                selena-users-service:latest
                
                EOF

  tags = {
    Name = "users-service-instance"
  }
}

resource "aws_security_group" "users_sg" {
  name        = "users-service-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH доступ — ограничим позже
  }

  ingress {
    from_port   = 9065
    to_port     = 9065
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow users-service access on port 9065"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.users_service.id
}