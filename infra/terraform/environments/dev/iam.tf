resource "aws_cloudwatch_log_group" "users_service_logs" {
  name              = "users-service-logs"
  retention_in_days = 14

  tags = {
    Project = "Selena"
    Service = "users-service"
  }
}
