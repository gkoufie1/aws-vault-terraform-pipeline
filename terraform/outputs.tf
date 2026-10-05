output "vault_public_ip" {
  value = aws_instance.vault.public_ip
}

output "vault_addr" {
  description = "Set this as VAULT_ADDR before running any vault CLI command against this instance"
  value       = "http://${aws_instance.vault.public_ip}:8200"
}
