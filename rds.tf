########################### rds subnet group ###########################
resource "aws_db_subnet_group" "subnet-group" {
  name        = "poc-rds-subnet-group"
  description = "poc-rds-subnet-group"
  subnet_ids  = local.subnet_ids
}

########################### rds-sg ###########################
resource "aws_security_group" "poc-rds-sg" {
  name   = "poc-rds-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "poc-rds-sg"
  }
}

########################### rds-client-sg ###########################
resource "aws_security_group" "poc-rds-client-sg" {
  name   = "poc-rds-client-sg"
  vpc_id = local.vpc_id

  ingress = []

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "poc-rds-sg"
  }
}

########################### rds ###########################
resource "aws_db_instance" "poc-rds" {
  instance_class                  = "db.t3.micro"
  engine                          = "mysql"
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = []
  engine_version                  = "8.0.35"
  vpc_security_group_ids          = [aws_security_group.poc-rds-sg.id, aws_security_group.poc-rds-client-sg.id]
  max_allocated_storage           = 1000
  copy_tags_to_snapshot           = true
  monitoring_interval             = 60
  skip_final_snapshot             = true

}
