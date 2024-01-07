## 내부 인스턴스
module "internal-instance" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "internal-a-instance"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = local.subnet_ids[0]

  instance_sg_ids = [aws_security_group.ssh-sg.id]

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
    "Team" : "dev"
  }
}

// 외부 서버
module "external-instance" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "external-b-instance"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = local.subnet_ids[0]

  instance_sg_ids = [aws_security_group.ssh-sg.id]

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

