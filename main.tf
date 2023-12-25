terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-lab4-iot"
    key            = "tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_secretsmanager_secret" "db-creds" {
  name = "prod/lab4/db-credentials"
}

resource "aws_secretsmanager_secret_version" "secret_credentials" {
  secret_id = aws_secretsmanager_secret.db-creds.id
  secret_string = jsonencode({
    "db_username" = var.db_username
    "db_password" = var.db_password
  })
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_subnet" "us_east_1a" {
  vpc_id     = aws_default_vpc.default.id
  cidr_block = "172.31.16.0/20"

  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "us_east_1b" {
  vpc_id     = aws_default_vpc.default.id
  cidr_block = "172.31.32.0/20"

  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
}

resource "aws_db_instance" "lab4_db" {
  allocated_storage                   = 20
  availability_zone                   = aws_subnet.us_east_1a.availability_zone
  backup_retention_period             = 1
  ca_cert_identifier                  = "rds-ca-2019"
  db_name                             = "lab4_db"
  engine                              = "mysql"
  engine_version                      = "8.0.33"
  max_allocated_storage               = 0
  identifier                          = "database-lab4-iot"
  iops                                = 0
  tags                                = {}
  port                                = 3306
  publicly_accessible                 = true
  instance_class                      = "db.t3.micro"
  username                            = jsondecode(aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_username"]
  password                            = jsondecode(aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_password"]
  storage_encrypted                   = true
  skip_final_snapshot                 = true
  customer_owned_ip_enabled           = false
  deletion_protection                 = false
  enabled_cloudwatch_logs_exports     = []
  iam_database_authentication_enabled = false
  vpc_security_group_ids              = [aws_security_group.default.id, aws_security_group.rds-ec2-1.id]
}

