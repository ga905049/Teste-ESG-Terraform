data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu-focal" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "amazon-linux-2-ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  project_name = "main-producao"
  vpc_cidr     = "10.50.0.0/16"
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
}
