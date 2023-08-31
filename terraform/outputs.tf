output "eipmanager1" {
  description = "Elastic IP Address Manager1"
  value       = aws_eip.dev-manager1-ip.public_ip
}
output "eipnogpu" {
  description = "Elastic IP Address nogpu"
  value       = aws_eip.dev-nogpu-ip.public_ip
}
output "eipgpu" {
  description = "Elastic IP Address gpu"
  value       = aws_eip.dev-gpu-ip.public_ip
}
