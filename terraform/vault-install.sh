#!/bin/bash
# Installs and starts real HashiCorp Vault — NOT "vault server -dev". Dev
# mode auto-unseals and throws away all data on restart, which isn't
# something worth describing in an interview as "how I ran Vault."
#
# Deliberately NOT done here: initializing or unsealing. Those produce the
# unseal keys and root token — generating those automatically and leaving
# them in a startup script log (visible to anyone who can read EC2 console
# output) would defeat the entire point of using Vault. That step is done
# by hand, over SSH, once the instance is up.
set -euxo pipefail

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum install -y vault

mkdir -p /etc/vault.d /opt/vault/data
chown -R vault:vault /opt/vault

cat >/etc/vault.d/vault.hcl <<'EOF'
storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

ui            = true
disable_mlock = true
EOF
# tls_disable and disable_mlock are both real shortcuts, not defaults —
# see the project README for what each one actually costs.

systemctl enable vault
systemctl start vault
