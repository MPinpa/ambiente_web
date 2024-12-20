# output "ec2_public_ip" {
#   description = "IP Publico a instancia EC2"
#   value       = module.app.ec2_public_ip
# }

# output "rds_endpoint" {
#   description = "Endpoint do RDS"
#   value       = module.app.rds_endpoint
# }

# output "rds_user" {
#   description = "Usuario do banco de dados"
#   value       = module.app.rds_user
#   sensitive   = true
# }

# output "rds_password" {
#   description = "Password do banco de dados"
#   value       = module.app.rds_password
#   sensitive   = true
# }

# output "private_key" {
#   description = "Chave privada para acessar a instance ec2"
#   value     = module.app.private_key
#   sensitive = false
# }

output "apps" {
    description = "Dados dos apps"
    value = {
        for count, app in module.app :
        module.app[count].name => {
            public_ip = app.ec2_public_ip
            rds_endpoint = app.rds_endpoint
            db_user = app.rds_user
            db_pass = app.rds_password
            key = app.private_key
        }
    }
    sensitive = true
}