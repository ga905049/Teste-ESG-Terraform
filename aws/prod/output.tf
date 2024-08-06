output "private_key" {
  value     = tls_private_key.infra-aws-pk.private_key_pem
  sensitive = true
}