variable "project_name" {
  type    = string
  default = "gitops-k8s-platform"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "your_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR notation, e.g. 1.2.3.4/32"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH access"
}

variable "db_password" {
  type        = string
  description = "Postgres master password"
  sensitive   = true
}
