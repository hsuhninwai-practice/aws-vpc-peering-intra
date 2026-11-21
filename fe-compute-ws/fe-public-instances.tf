data "aws_ami" "fe_public_instance_ami" {

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_eip" "frontend_public_instance_eip" {

  tags = {
    name        = "${var.frontend_prefix}-public-instance-eip-${var.region}"
    environment = "${var.frontend_environment}"
  }
}

resource "aws_eip_association" "fe_public_instance_eip_assoc" {
  instance_id   = aws_instance.frontend_public_instance01.id
  allocation_id = aws_eip.frontend_public_instance_eip.id
}

resource "aws_instance" "frontend_public_instance01" {
  ami                    = data.aws_ami.fe_public_instance_ami.id
  instance_type          = var.fe_instance_type
  key_name               = aws_key_pair.fe_keypair.key_name
  subnet_id              = data.terraform_remote_state.frontend_network.outputs.frontend_public_subnet01_id
  vpc_security_group_ids = [data.terraform_remote_state.frontend_security.outputs.fe_public_sg01_id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.frontend_prefix}-public-instance01"
    environment = "${var.frontend_environment}"
  }
}

resource "null_resource" "configure-fe-public-instance01" {
  depends_on = [aws_instance.frontend_public_instance01, aws_eip_association.fe_public_instance_eip_assoc]

  triggers = {
    build_number = timestamp()
  }

  provisioner "file" {
    source      = "${path.module}/files/"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.fe_keypair.private_key_pem
      host        = aws_eip.frontend_public_instance_eip.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      # Update YUM-based package index
      "sudo apt -y update",

      # Install Apache httpd only if not present
      "if ! dpkg -s apache2 >/dev/null 2>&1; then sudo apt -y install apache2; fi",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",

      # Fix permissions if directory exists
      "if [ -d /var/www/html ]; then sudo chown -R ubuntu:ubuntu /var/www/html; fi",

      # Make scripts executable if any exist
      "if ls *.sh 1> /dev/null 2>&1; then chmod +x *.sh; fi",

      # Run your deployment script if it exists
      "if [ -f ./deploy_app.sh ]; then PLACEHOLDER=${var.fe_placeholder} WIDTH=${var.width} HEIGHT=${var.height} PLACEHOLDER_ID=${var.placeholder_id} PREFIX=${var.frontend_prefix} ./deploy_app.sh; fi",

      # Install cowsay if not present
      "if ! command -v cowsay >/dev/null 2>&1; then sudo apt -y install cowsay; fi",
      "cowsay Hellooooooooooo!",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.fe_keypair.private_key_pem
      host        = aws_eip.frontend_public_instance_eip.public_ip
    }
  }
}
