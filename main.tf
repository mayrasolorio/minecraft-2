terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 4.0" }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "mc_sg" {
  name        = "minecraft-sg-tf"
  description = "Allow SSH & Minecraft"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mc" {
  ami                    = "ami-082945e2727784f8c"  # Amazon Linux 2 (us-west-2)
  instance_type          = "t4g.small"
  key_name               = var.key_name
  vpc_security_group_ids = [ aws_security_group.mc_sg.id ]


  # AUTOMATED CONFIGURATION
  provisioner "file" {
    source      = "scripts/configure-server.sh"
    destination = "/home/ec2-user/configure-server.sh"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("~/.ssh/key_pair.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/configure-server.sh",
      "sudo /home/ec2-user/configure-server.sh"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("~/.ssh/key_pair.pem")
    }
  }
}

