module "vpc_producao" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.project_name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 80)]

  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

resource "aws_route" "private-subnet-a-route" {
  route_table_id         = element(module.vpc_producao.private_route_table_ids, 0)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat-gw.primary_network_interface_id
}

resource "aws_route" "private-subnet-b-route" {
  route_table_id         = element(module.vpc_producao.private_route_table_ids, 1)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat-gw.primary_network_interface_id
}

resource "aws_route" "private-subnet-c-route" {
  route_table_id         = element(module.vpc_producao.private_route_table_ids, 2)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat-gw.primary_network_interface_id
}
