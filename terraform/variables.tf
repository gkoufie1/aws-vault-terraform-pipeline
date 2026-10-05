variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "vault-pipeline"
}

variable "my_ip" {
  description = "Your own public IP, in CIDR form (e.g. 1.2.3.4/32) — the only address allowed to reach Vault's UI/API and SSH"
  type        = string
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair in this region, for SSH access to run vault operator init/unseal by hand"
  type        = string
}
