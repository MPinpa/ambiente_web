## AUTENTICATION
######################

region = "us-east-1"
access_key = ""
secret_key = ""

## PROJECT
#####################

project_name = "suporteshow"
env_name = "prod"

## NETWORK
#####################

vpc_cidr_block = "10.0.0.0/16"
public_subnets_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24"]

## APPS
####################

apps = [
  {
    app_name = "suporteshow"
    ingress_allow = [
      {
        port         = 80
        protocol     = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
      },
      {
        port         = 443
        protocol     = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
      },
      {
        port         = 22
        protocol     = "tcp"
        cidr_blocks  = ["170.233.250.6/32"]
      }
    ]
  }
  # NOVAS APLICAÇÕES PODEM SER INSERIDAS A PARTIR DAQUI
]
