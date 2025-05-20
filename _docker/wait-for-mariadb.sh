#!/bin/bash

# Проверяем, доступна ли база данных MariaDB
until mysql -h mariadb -u root -ppassword -e "SELECT 1"; do
  echo "Waiting for MariaDB to be available..."
  sleep 2
done

# После того как база данных доступна, запускаем Spring Boot приложение
java -jar /app.jar
