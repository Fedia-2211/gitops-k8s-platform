# ─── DB Subnet Group ────────────────────────────────────────────────────────
# RDS requires subnets in at least 2 different AZs, even for a single-AZ DB.
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [var.private_subnet_id, var.private_subnet_2_id]

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# ─── RDS Postgres Instance ─────────────────────────────────────────────────
# Outline requires Postgres 12+. We use the smallest instance class
# (db.t3.micro) which is Free Tier eligible for 12 months on new accounts.
resource "aws_db_instance" "postgres" {
  identifier     = "${var.project_name}-${var.environment}-postgres"
  engine         = "postgres"
  engine_version = "15.7"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  # Portfolio project - skip final snapshot for easy destroy
  skip_final_snapshot = true

  # Single-AZ to keep cost down (Multi-AZ doubles the cost)
  multi_az = false

  # Disable automated backups to avoid extra cost (not needed for portfolio)
  backup_retention_period = 0

  publicly_accessible = false

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}
