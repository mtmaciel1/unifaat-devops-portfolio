output "ec2_public_ip" {
  description = "IP público da EC2"
  value       = aws_instance.app_server.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do RDS PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "Address do RDS"
  value       = aws_db_instance.postgres.address
}