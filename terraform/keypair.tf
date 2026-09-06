# Pasangan kunci khusus untuk controller SSH masuk ke web + monitoring server.
# Kunci private dibenamkan terus dalam user_data controller (lihat ec2.tf),
# tidak pernah disimpan dalam repo.
resource "tls_private_key" "controller" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "controller" {
  key_name   = "devops-fyp-controller-key"
  public_key = tls_private_key.controller.public_key_openssh
}
