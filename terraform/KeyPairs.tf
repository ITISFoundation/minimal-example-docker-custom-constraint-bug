resource "aws_key_pair" "testing" {
  key_name   = "testing"
  public_key = tls_private_key.testing.public_key_openssh
  # Store private key :  Generate and save private key in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.testing.private_key_pem}' > ${path.module}/key.pem
      echo '${tls_private_key.testing.private_key_openssh}' > ${path.module}/key_openssh.pem
      echo '${tls_private_key.testing.private_key_pem_pkcs8}' > ${path.module}/key_pkcs8.pem
      echo '${tls_private_key.testing.public_key_pem}' > ${path.module}/key.pub
      echo '${tls_private_key.testing.public_key_openssh}' > ${path.module}/key_openssh.pub
      chmod 400 key.pem
    EOT
  }
}
resource "tls_private_key" "testing" {
  algorithm = "ED25519"
}
