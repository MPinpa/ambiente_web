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

## NETWORK
#######################

variable "vpc_cidr_block" {
  description = "O CIDR block da"
  type = string
}

variable "public_subnets" {
  description = "Lista de CIDR block de subnets privadas"
  type = list(string)
  default = []
}

variable "private_subnets" {
  description = "Lista de CIDR block de subnets privadas"
  type = list(string)
  default = []
}