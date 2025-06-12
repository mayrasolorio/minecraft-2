output "public_ip" {
  description = "Public IPv4 address of the Minecraft server"
  value       = aws_instance.mc.public_ip
}

output "instance_id" {
  description = "ID of the Minecraft EC2 instance"
  value       = aws_instance.mc.id
}

