output "k3s_server_public_ip" {
  description = "SSH here and use this for kubectl"
  value       = module.compute.k3s_server_public_ip
}

output "k3s_server_private_ip" {
  value = module.compute.k3s_server_private_ip
}

output "k3s_agent_private_ip" {
  value = module.compute.k3s_agent_private_ip
}

output "db_endpoint" {
  description = "Postgres connection endpoint (host:port)"
  value       = module.rds.db_endpoint
}

output "db_address" {
  description = "Postgres host only (no port) - use this in K8s secrets"
  value       = module.rds.db_address
}

output "db_name" {
  value = module.rds.db_name
}

output "db_username" {
  value = module.rds.db_username
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
