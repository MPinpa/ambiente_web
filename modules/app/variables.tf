## PROJECT
#####################

variable "project_name" {
  description = "Nome do projeto"
  type = string
}

variable "env_name" {
  description = "Nome do ambiente (exemplo: dev, qa, prod)"
  type = string
}

variable "app_name" {
  description = "Nome da aplicação"
  type = string
}

## Instance
#######################

variable "ami_id" {
  description = "Id da imagem AMI (default. Ubuntu 24.04)"
  type = string
  default = "ami-0e2c8caa4b6378d8c"
}

variable "instance_type" {
  description = "Tipo da instancia (Default. t3.micro)"
  type = string
  default = "t3.micro"
}

## Network
#######################

variable "vpc_id" {
  description = "Id da vpc"
  type = string
}

variable "public_subnet_ids" {
  description = "IDs da Subnet publica"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "IDs da Subnets privadas"
  type = list(string)
}

## Firewall
#####################

variable "ingress_allow" {
  description = "Redes e portas permitidas"
  type = list(object({
    port = number
    cidr_blocks = list(string)
    protocol = string
  }))
  default = [ 
    {
    port = 22
    cidr_blocks = ["170.233.250.6/32"]
    protocol = "tcp"
    }]
}

## RDS
#####################

variable "storage" {
  description = "Tamanho do disco do RDS"
  type = number
  default = 20
}

variable "rds_instance_class" {
  description = "A Capacidade do RDS CPU e RAM"
  type = string
  default = "db.t3.micro"
}

## APP
#####################

variable "app_id" {
  description = "ID do aplicativo"
  type = number
}