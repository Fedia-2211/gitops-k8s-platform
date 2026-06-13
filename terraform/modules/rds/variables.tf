variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "rds_sg_id" {
  type = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type    = string
  default = "outline"
}

variable "db_username" {
  type    = string
  default = "outline_admin"
}

variable "db_password" {
  type        = string
  description = "Postgres master password - pulled from SSM"
  sensitive   = true
}
