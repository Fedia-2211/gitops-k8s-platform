terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Reuse the same S3 backend
  # state file key.
  backend "s3" {
    bucket = "gitops-k8s-platform"
    key    = "gitops-k8s-platform/production/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# ─── VPC ────────────────────────────────────────────────────────────────────
module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}

# ─── Security Groups ───────────────────────────────────────────────────────
module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr
  your_ip_cidr = var.your_ip_cidr
}

# ─── Compute (k3s server + agent) ──────────────────────────────────────────
module "compute" {
  source = "../../modules/compute"

  project_name      = var.project_name
  environment       = var.environment
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  k3s_server_sg_id  = module.security.k3s_server_sg_id
  k3s_agent_sg_id   = module.security.k3s_agent_sg_id
  key_name          = var.key_name
}

# ─── RDS Postgres ───────────────────────────────────────────────────────────
module "rds" {
  source = "../../modules/rds"

  project_name        = var.project_name
  environment         = var.environment
  private_subnet_id   = module.vpc.private_subnet_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  rds_sg_id           = module.security.rds_sg_id
  db_password         = var.db_password
}
