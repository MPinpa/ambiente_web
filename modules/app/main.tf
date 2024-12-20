## Gera chave localmente
##########################

resource "tls_private_key" "main" {

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "main" {

  key_name   = "key-${var.env_name}-${var.app_name}-${var.project_name}"
  public_key = tls_private_key.main.public_key_openssh
}

## Firewall
##########################

resource "aws_security_group" "ec2" {
  name_prefix = "ec2-sg-${var.env_name}-${var.app_name}-${var.project_name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_allow
    content {
        from_port   = ingress.value.port
        to_port     = ingress.value.port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-${var.env_name}-${var.app_name}-${var.project_name}"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "rds-sg-${var.env_name}-${var.app_name}-${var.project_name}"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-${var.env_name}-${var.app_name}-${var.project_name}"
  }
}

## Bucket S3
############################

resource "aws_s3_bucket" "main" {
  bucket = "bucket-${var.env_name}-${var.app_name}-${var.project_name}"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

## Cria a Instancia EC2
############################

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.public_subnet_ids, var.app_id)
  key_name      = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile = aws_iam_instance_profile.main.name

  tags = {
    Name = "ec2-${var.env_name}-${var.app_name}-${var.project_name}"
  }
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"
}

## Gerando senha para o banco
##############################

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!@#%^&*()-_+=" 
}

## Subnet Group
#############################

resource "aws_db_subnet_group" "main" {
  name       = "my-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
}

## Banco de dados MySQL RDS
#############################

resource "aws_db_instance" "mysql" {
  identifier              = "mysql-db-${var.env_name}-${var.app_name}-${var.project_name}"
  allocated_storage       = var.storage
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.rds_instance_class
  username                = var.project_name
  password                = random_password.rds_password.result
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
}
