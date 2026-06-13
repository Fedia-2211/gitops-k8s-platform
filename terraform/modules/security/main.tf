# ─── k3s Server Security Group ────────────────────────────────────────────
# The server node runs the control plane (API server) and can also run pods.
# We need:
#  - SSH from your IP (to install k3s, debug)
#  - 6443 from your IP (kubectl access to the API server)
#  - 6443 from the agent (so the agent can join the cluster)
#  - k3s flannel VXLAN (8472/udp) between server and agent
#  - kubelet metrics (10250) between nodes
#  - HTTP/HTTPS from internet (for Outline + ArgoCD + Grafana via Ingress)
resource "aws_security_group" "k3s_server" {
  name        = "${var.project_name}-${var.environment}-sg-k3s-server"
  description = "k3s server: API access, SSH, ingress traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  ingress {
    description = "Kubernetes API server from admin IP (kubectl)"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  ingress {
    description = "Kubernetes API server from agent nodes"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Flannel VXLAN between nodes"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Kubelet metrics between nodes"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "HTTP from internet (Ingress)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet (Ingress)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-k3s-server"
  }
}

# ─── k3s Agent Security Group ─────────────────────────────────────────────
# The agent only needs to talk to the server and accept SSH from us.
resource "aws_security_group" "k3s_agent" {
  name        = "${var.project_name}-${var.environment}-sg-k3s-agent"
  description = "k3s agent: joins server, SSH from admin"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  ingress {
    description = "Flannel VXLAN between nodes"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Kubelet metrics between nodes"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-k3s-agent"
  }
}

# ─── RDS Security Group ────────────────────────────────────────────────────
# Only the k3s nodes (server + agent, since pods can run on either)
# should be able to reach Postgres on 5432.
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-sg-rds"
  description = "RDS Postgres: 5432 from k3s nodes only"
  vpc_id      = var.vpc_id

  ingress {
    description = "Postgres from k3s server"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.k3s_server.id]
  }

  ingress {
    description = "Postgres from k3s agent"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.k3s_agent.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-rds"
  }
}
