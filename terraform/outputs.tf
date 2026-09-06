output "web_public_ip" { value = aws_eip.web.public_ip }
output "web_private_ip" { value = "10.0.0.5" }
output "controller_private_ip" { value = "10.0.0.135" }
output "monitoring_private_ip" { value = "10.0.0.136" }
output "ecr_repository_url" { value = aws_ecr_repository.app.repository_url }
