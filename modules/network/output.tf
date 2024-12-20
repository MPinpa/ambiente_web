output "vpc_id" {
  description = "Id da VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "O CIDR BLOCK da VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnets_cidr" {
  description = "Os CIDR BLOCKs das subents publicas"
  value       = length(var.public_subnets) > 0 ? aws_subnet.public[*].cidr_block : []
}

output "private_subnets_cidr" {
  description = "Os CIDR BLOCKs das subents privadas"
  value       = length(var.private_subnets) > 0 ? aws_subnet.private[*].cidr_block : []
}

output "public_subnets_ids" {
  description = "Os CIDR BLOCKs das subents publicas"
  value       = length(var.public_subnets) > 0 ? aws_subnet.public[*].id : []
}

output "private_subnets_ids" {
  description = "Os CIDR BLOCKs das subents privadas"
  value       = length(var.private_subnets) > 0 ? aws_subnet.private[*].id : []
}