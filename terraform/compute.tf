data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  # "al2023-ami-2023.*" rather than "al2023-ami-*" — the looser pattern also
  # matches Amazon's ECS/Neuron variants (al2023-ami-ecs-neuron-...), and
  # most_recent can silently pick one of those instead of plain AL2023.
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "vault" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro" # free-tier eligible
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.vault.id]
  key_name               = var.key_pair_name
  user_data              = file("${path.module}/vault-install.sh")

  tags = { Name = "${var.project_name}-vault" }
}
