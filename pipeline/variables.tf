# Set these as environment variables (TF_VAR_approle_role_id /
# TF_VAR_approle_secret_id), never in a .tfvars file.
variable "approle_role_id" {
  description = "AppRole role_id for the terraform-pipeline role — an identifier, not a secret on its own"
  type        = string
}

variable "approle_secret_id" {
  description = "AppRole secret_id — the actual credential; short-lived, generate a fresh one per run"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "vault-pipeline"
}

variable "secret_version" {
  description = "Bump to re-push db_password from Vault to SSM — write-only values leave Terraform nothing to diff against"
  type        = number
  default     = 1
}
