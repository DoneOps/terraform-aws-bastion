output "incoming_security_group_id" {
  description = "Security group ID for bastion sg"
  value       = aws_security_group.allow_bastion_ssh_sg.id
}

output "bastion_private_key" {
  value     = tls_private_key.bastion.private_key_pem
  sensitive = true
}
