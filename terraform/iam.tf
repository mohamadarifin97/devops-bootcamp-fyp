# Role sedia ada dalam akaun latihan (bukan dicipta oleh Terraform ini) —
# ikut corak yang sama digunakan dalam devops-bootcamp/terraform2-4.
# Nota: kalau web server gagal `docker pull` dari ECR sebab access denied,
# minta polisi AmazonEC2ContainerRegistryReadOnly dilampirkan pada role ini.
data "aws_iam_instance_profile" "ssm" {
  name = "EC2-SSM-role"
}
