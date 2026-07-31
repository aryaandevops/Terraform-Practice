resource "aws_db_instance" "mysql" {
  identifier = "terraform-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro" # Free Tier eligible (or db.t2.micro for older accounts)

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "mydatabase"
  username = "admin"
  password = "Password@123"

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  multi_az            = false

  storage_encrypted = false

  backup_retention_period = 0

  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  tags = {
    Name = "Terraform-RDS"
  }
}
