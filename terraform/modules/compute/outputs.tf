output "k3s_server_public_ip" {
  value = aws_instance.k3s_server.public_ip
}

output "k3s_server_private_ip" {
  value = aws_instance.k3s_server.private_ip
}

output "k3s_agent_private_ip" {
  value = aws_instance.k3s_agent.private_ip
}

output "k3s_server_id" {
  value = aws_instance.k3s_server.id
}

output "k3s_agent_id" {
  value = aws_instance.k3s_agent.id
}
