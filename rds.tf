########################### rds subnet group ###########################
resource "aws_db_subnet_group" "subnet-group" {
  name        = "poc-rds-subnet-group"
  description = "poc-rds-subnet-group"
  subnet_ids  = local.subnet_ids
}

########################### rds ###########################
resource "aws_db_instance" "poc-rds" {
  db_name                         = "poc_rds"
  identifier                      = "default-rds"
  instance_class                  = "db.t3.micro"
  engine                          = "mysql"
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = []
  engine_version                  = "8.0.35"

  vpc_security_group_ids = [
    aws_security_group.default-rds-sg.id,
    aws_security_group.external-sg.id,
    aws_security_group.dev-team-sg.id,
    aws_security_group.ds-team-sg.id,
    aws_security_group.vpn-sg.id
  ]

  max_allocated_storage = 1000
  copy_tags_to_snapshot = true
  skip_final_snapshot   = true
  username              = "root"
  password              = "12341234"
  publicly_accessible   = true
  db_subnet_group_name  = aws_db_subnet_group.subnet-group.name
  storage_type          = "gp2"
  allocated_storage     = 100
  availability_zone     = "ap-northeast-2a"

  iam_database_authentication_enabled = false
  customer_owned_ip_enabled           = false

  lifecycle {
    ignore_changes = [password]
  }
}
