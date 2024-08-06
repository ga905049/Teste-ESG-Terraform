resource "tls_private_key" "infra-aws-pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "infra-prod-key" {
  key_name   = "infra-prod"
  public_key = tls_private_key.infra-aws-pk.public_key_openssh
}