## VPC
########################

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  tags = {
    Name = "vpc-${var.env_name}-${var.project_name}"
  }
}

## SUBNETS
#########################

# Gera as zonas disponveis
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {

  count = var.public_subnets != null ? length(var.public_subnets) : 0
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index) # trabalha com o indice, caso indice for maior ele inicia do inicio da lista
  tags = {
    Name = "subnet-${var.env_name}-${var.project_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {

  count = var.private_subnets != null ? length(var.private_subnets) : 0
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index) # trabalha com o indice, caso indice for maior ele inicia do inicio da lista
  tags = {
    Name = "subnet-${var.env_name}-${var.project_name}-private-${count.index}"
  }
}

## Internet Gateway
##########################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.env_name}-${var.project_name}"
  }
}

## Tabela de Rotas
#########################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rtb-${var.env_name}-${var.project_name}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rtb-${var.env_name}-${var.project_name}-private"
  }
}

resource "aws_route_table_association" "public" {
  count = var.public_subnets != null ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = var.private_subnets != null ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}