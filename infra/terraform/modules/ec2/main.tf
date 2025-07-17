# -----------------------
# USERS-SERVICE
# -----------------------

resource "aws_instance" "users_service" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.users_sg.id]
  key_name      = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

    user_data = <<-EOF
                #!/bin/bash

                # Лог в файл для отладки
                exec > /var/log/user-data.log 2>&1

                # Обновление системы
                yum update -y

                # Установка Docker
                amazon-linux-extras enable docker
                yum install -y docker git
                systemctl start docker
                systemctl enable docker

                # Добавить ec2-user в группу docker
                usermod -aG docker ec2-user

                # Клонируем репозиторий, если не существует
                cd /home/ec2-user
                if [ ! -d "/home/ec2-user/selena-users-service" ]; then
                  git clone https://github.com/vitalii-q/selena-users-service.git
                  chown -R ec2-user:ec2-user selena-users-service   # установить права
                else
                  cd selena-users-service
                  sudo -u ec2-user git pull                       # обновить код
                  cd ..
                fi

                # Проверяем и скачиваем .env
                if [ ! -f /home/ec2-user/selena-users-service/.env ]; then
                  echo ".env не найден, скачиваем из S3..."
                  aws s3 cp s3://selena-users-service-env-dev/.env /home/ec2-user/selena-users-service/.env
                  chown ec2-user:ec2-user /home/ec2-user/selena-users-service/.env
                else
                  echo ".env уже существует"
                fi

                cd /home/ec2-user/selena-users-service

                # Собираем образ всегда
                sudo -u ec2-user docker build -t selena-users-service .

                # Останавливаем старый контейнер, если он есть
                if docker ps -a --format '{{.Names}}' | grep -q '^selena-users-service$'; then
                  docker stop selena-users-service
                  docker rm selena-users-service
                fi

                # Запускаем контейнер
                sudo -u ec2-user docker run -d \
                --name selena-users-service \
                --env-file /home/ec2-user/selena-users-service/.env \
                -p 9065:9065 \
                --restart always \
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
  instance = aws_instance.users_service[0].id

  lifecycle {
    prevent_destroy = true
  }
}