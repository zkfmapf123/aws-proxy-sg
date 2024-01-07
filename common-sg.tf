################### ssh-sg ###################
resource "aws_security_group" "ssh-sg" {
  name   = "ssh-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-sg"
  }
}

################### proxy-sg ###################
resource "aws_security_group" "proxy-sg" {
  name   = "proxy-sg"
  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "proxy-sg"
  }
}

################### Dev_Team_sg ###################
resource "aws_security_group" "dev-team-sg" {
  name   = "dev-team-sg"
  vpc_id = local.vpc_id

  ingress = []
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-team-sg"
    Team = "dev"
  }
}

################### DS_Team_sg ###################
resource "aws_security_group" "ds-team-sg" {
  name   = "ds-team-sg"
  vpc_id = local.vpc_id

  ingress = []
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ds-team-sg"
    Team = "ds"
  }
}

################### VPN SG ###################
resource "aws_security_group" "vpn-sg" {
  name   = "vpn-sg"
  vpc_id = local.vpc_id

  ingress = []
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-sg"
  }
}

################### External SG ###################
resource "aws_security_group" "external-sg" {
  name   = "external-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "external-sg"
  }
}

################### default-rds-sg ###################
resource "aws_security_group" "default-rds-sg" {
  name   = "default-rds-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy-sg.id]
    description     = "proxy-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-rds-sg"
  }
}
