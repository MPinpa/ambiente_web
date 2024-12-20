output "ec2_public_ip" {
  description = "IP Publico a instancia EC2"
  value       = aws_instance.main.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_user" {
  description = "Usuario do banco de dados"
  value       = aws_db_instance.mysql.username
}

output "rds_password" {
  description = "Password do banco de dados"
  value       = random_password.rds_password.result
}

output "private_key" {
  description = "Chave privada para acessar a instance ec2"
  value     = tls_private_key.main.private_key_pem
}

output "name" {
  description = "Nome do app"
  value = var.app_name
}