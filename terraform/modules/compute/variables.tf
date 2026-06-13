variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "k3s_server_sg_id" {
  type = string
}

variable "k3s_agent_sg_id" {
  type = string
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair for SSH access"
}

variable "server_instance_type" {
  type    = string
  default = "c7i-flex.large"
}

variable "agent_instance_type" {
  type    = string
  default = "t3.small"
}
