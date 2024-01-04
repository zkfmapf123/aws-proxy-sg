resource "aws_security_group" "poc-default-ins-sg" {
  vpc_id      = local.vpc_id
  name        = "poc-default-ins-sg"
  description = "poc-default-ins-sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "poc-default-ins-sg"
  }
}

resource "aws_security_group" "external-ips-sg" {
  vpc_id      = local.vpc_id
  name        = "external-ips-sg"
  description = "external-ips-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${module.external-instance.out.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "external-ips-sg"
  }

  depends_on = [module.default-ins]
}

## 내부 인스턴스
module "internal-instance" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "internal-instance"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = local.subnet_ids[0]

  # Proxy-sg를 사용할 경우
  instance_sg_ids = [aws_security_group.poc-default-ins-sg.id, aws_security_group.poc-rds-client-sg.id]

  ## External-ip를 사용할 경우
  #   instance_sg_ids = [aws_security_group.poc-default-ins-sg.id]

  instance_ip_attr = {
    is_public_ip  = true
    is_eip        = true
    is_private_ip = false
    private_ip    = ""
  }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = true
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform",
    "Name" : "내부_개발용_인스턴스"
  }
}

// 외부 서버
module "external-instance" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "external-instance"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = local.subnet_ids[0]

  ## External-ip를 사용할 경우
  instance_sg_ids = [aws_security_group.poc-default-ins-sg.id]

  instance_ip_attr = {
    is_public_ip  = true
    is_eip        = true
    is_private_ip = false
    private_ip    = ""
  }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = true
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform",
    "Name" : "외부_인스턴스"
  }
}

