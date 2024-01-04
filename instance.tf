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

## Freetier는 cpu 옵션을 사용할수 없습니다.
module "default-ins" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "default-ins"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = local.subnet_ids[0]
  instance_sg_ids    = [aws_security_group.poc-default-ins-sg.id]

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
    "MadeBy" : "terraform"
  }
}
