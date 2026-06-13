variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "your_ip_cidr" {
  type        = string
  description = "Your IP in CIDR notation for SSH and kubectl access"
}
