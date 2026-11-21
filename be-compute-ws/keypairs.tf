locals {
  be_private_key_filename = "be_keypair.pem"
}

resource "tls_private_key" "be_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "be_keypair" {
  key_name   = local.be_private_key_filename
  public_key = tls_private_key.be_keypair.public_key_openssh
}

output "be_private_key" {
  description = "Backend SSH private key"
  value       = tls_private_key.be_keypair.private_key_openssh
  sensitive   = true
}