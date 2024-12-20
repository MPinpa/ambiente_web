## Autenticação 
#######################

variable "region" {
  description = "Regiao da AWS"
  type = string
}

variable "access_key" {
  description = "Access key da aws para autenticacao"
  type = string
  default = null
}

variable "secret_key" {
  description = "Secret key da aws para autenticacao"
  type = string
  default = null
}

## PROJETO
#######################

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

variable "public_subnets_cidr" {
  description = "Range de Ip da subnet publica"
  type = list(string)
  default = []
}

variable "private_subnets_cidr" {
  description = "Range de Ip da subnet privada"
  type = list(string)
  default = []
}

variable "apps" {
  description = "Os aplicativos que devem ser criados"
  type = any
}