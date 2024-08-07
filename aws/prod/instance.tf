resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu-focal.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.infra-prod-key.key_name
  associate_public_ip_address = "true"
  subnet_id                   = element(module.vpc_producao.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  user_data                   = <<EOF
  #!/bin/bash
  apt-get update
  apt-get -y install ansible
  EOF

  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "nat-gw" {
  ami                         = data.aws_ami.amazon-linux-2-ami.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.infra-prod-key.key_name
  associate_public_ip_address = "true"
  subnet_id                   = element(module.vpc_producao.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.nat-gw-sg.id]
  source_dest_check           = false
  user_data                   = <<EOF
  #!/bin/bash
  sudo sysctl -w net.ipv4.ip_forward=1
  sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  sudo yum install -y iptables-services
  sudo service iptables save
  EOF

  tags = {
    Name = "Nat Gateway"
  }
}

resource "aws_instance" "docker-server" {
  ami                    = data.aws_ami.ubuntu-focal.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.infra-prod-key.key_name
  subnet_id              = element(module.vpc_producao.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.docker-server-sg.id]
  user_data              = <<EOF
#!/bin/bash
# Install docker
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu

systemctl enable docker
systemctl start docker
EOF

  tags = {
    Name = "Docker Server"
  }
}
