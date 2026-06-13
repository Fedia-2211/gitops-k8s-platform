# ─── Latest Ubuntu 22.04 AMI ────────────────────────────────────────────────
data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ─── k3s Server Node ────────────────────────────────────────────────────────
# Runs the control plane (API server, scheduler, controller-manager, etcd)
# AND can schedule workload pods. Public subnet so we can kubectl directly.
resource "aws_instance" "k3s_server" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = var.server_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.k3s_server_sg_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-k3s-server"
    Role = "k3s-server"
  }
}

# ─── k3s Agent Node ──────────────────────────────────────────────────────────
# Joins the server as a worker. Private subnet - no public IP needed,
# reaches internet via NAT for pulling container images.
resource "aws_instance" "k3s_agent" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = var.agent_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.k3s_agent_sg_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-k3s-agent"
    Role = "k3s-agent"
  }
}
