# Reads secret/pipeline/app from the KV v2 engine. The AppRole's policy only
# allows read on secret/data/pipeline/*, so this is the whole blast radius
# if its credentials leak.
#
# Ephemeral, not a data source: Terraform fetches the secret during the run
# and then forgets it — it is never written to terraform.tfstate or a plan
# file. A data source would store the plaintext value in state, which
# quietly recreates the copy-outside-Vault problem Vault exists to prevent.
ephemeral "vault_kv_secret_v2" "app" {
  mount = "secret"
  name  = "pipeline/app"
}

# Delivers the password to where an app on AWS would read it at runtime.
# value_wo is write-only: sent to AWS, never stored in state. Because
# Terraform keeps no copy to diff against, it can't notice when the Vault
# value changes — bump secret_version to push a new one.
resource "aws_ssm_parameter" "db_password" {
  name             = "/${var.project_name}/app/db_password"
  type             = "SecureString" # encrypted with the AWS-managed aws/ssm key — free
  value_wo         = ephemeral.vault_kv_secret_v2.app.data["db_password"]
  value_wo_version = var.secret_version
}

# The username isn't really secret, but it comes from the same ephemeral
# read — and ephemeral values may only flow into write-only arguments.
resource "aws_ssm_parameter" "db_username" {
  name             = "/${var.project_name}/app/db_username"
  type             = "String"
  value_wo         = ephemeral.vault_kv_secret_v2.app.data["db_username"]
  value_wo_version = var.secret_version
}
