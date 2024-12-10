resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/app/logs"
  retention_in_days = 14
  tags = {
    Environment = "Production"
  }
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app_logs.name
}
