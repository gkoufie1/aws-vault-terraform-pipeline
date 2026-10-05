# A separate root from ../terraform on purpose: that one builds the Vault
# server, so it can't also depend on Vault being up — a fresh rebuild would
# have nothing to authenticate against. This root is the consumer side.
terraform {
  # 1.11+ for write-only arguments (value_wo); ephemeral resources need 1.10.
  required_version = ">= 1.11"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "kwesi" # same pin as ../terraform — "default" is a different account

  default_tags {
    tags = {
      Project = var.project_name
    }
  }
}

# Address comes from VAULT_ADDR; role_id/secret_id come from TF_VAR_* env
# vars. Nothing that grants access to Vault is written to a file here.
provider "vault" {
  # The provider normally mints a child token from whatever it logs in
  # with, which needs auth/token/create — a permission this AppRole's
  # read-only policy deliberately doesn't have.
  skip_child_token = true

  # Provider 5.x has no dedicated AppRole block, so this is the generic
  # login: a PUT to auth/approle/login with role_id + secret_id.
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.approle_role_id
      secret_id = var.approle_secret_id
    }
  }
}
