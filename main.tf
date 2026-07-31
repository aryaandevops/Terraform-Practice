terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "rds_sg" {
  name        = "terraform-rds-sg"
  description = "Security Group for RDS"
  vpc_id      = "vpc-084e2337fc593fa47"

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For testing only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-rds-sg"
  }
}

# -----------------------------
# DB Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "rds_subnet" {
  name = "terraform-rds-subnet-group"

  subnet_ids = [
    "subnet-00ef282a74e1955d8",
    "subnet-05da271feec127ce4"
  ]

  tags = {
    Name = "terraform-rds-subnet-group"
  }
}

# -----------------------------
# RDS MySQL Instance
# -----------------------------
resource "aws_db_instance" "mysql" {
  identifier = "terraform-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "mydatabase"
  username = "admin"
  password = "aryan@0612"

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  multi_az            = false

  storage_encrypted      = false
  backup_retention_period = 0

  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  tags = {
    Name = "Terraform-RDS"
  }
}

# -----------------------------
# Outputs
# -----------------------------
output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  value = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}
