output "controller_public_ip" {
  description = "Public IP of controller node"
  value       = aws_instance.controller.public_ip
}

output "managed_public_ip" {
  description = "Public IP of managed node"
  value       = aws_instance.managed.public_ip
}
