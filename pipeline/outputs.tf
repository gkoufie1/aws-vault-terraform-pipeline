# Parameter names only — the secret value is deliberately not an output
# (an ephemeral value can't be one, which is the point).
output "ssm_parameters" {
  value = [
    aws_ssm_parameter.db_password.name,
    aws_ssm_parameter.db_username.name,
  ]
}
