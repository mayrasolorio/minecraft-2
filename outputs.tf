output "public_ip" {
  description = "Minecraft server IP"
  value       = aws_instance.mc.public_ip
}
