data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
data "aws_ssm_parameter" "tunnel_token" {
  name = "/devops-bootcamp-fyp/tunnel-token"
}

module "web_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                   = "devops-web-server"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.devops_vpc.public_subnets[0]
  private_ip             = "10.0.0.5"
  create_security_group  = false
  vpc_security_group_ids = [module.public_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.ssm.name
  key_name               = aws_key_pair.controller.key_name

  tags = { Name = "devops-web-server" }
}

resource "aws_eip" "web" {
  domain   = "vpc"
  instance = module.web_server.id
  tags     = { Name = "devops-web-eip" }
}

module "monitoring_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                   = "devops-monitoring-server"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.devops_vpc.private_subnets[0]
  private_ip             = "10.0.0.136"
  create_security_group  = false
  vpc_security_group_ids = [module.private_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.ssm.name
  key_name               = aws_key_pair.controller.key_name

  tags = { Name = "devops-monitoring-server" }
}

module "controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                   = "devops-ansible-controller"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.devops_vpc.private_subnets[0]
  private_ip             = "10.0.0.135"
  create_security_group  = false
  vpc_security_group_ids = [module.private_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.ssm.name

  user_data = templatefile("userdata-controller.sh.tftpl", {
    private_key             = tls_private_key.controller.private_key_openssh
    web_ip                  = "10.0.0.5"
    monitoring_ip           = "10.0.0.136"
    cloudflare_tunnel_token = data.aws_ssm_parameter.tunnel_token.value
    ecr_repository_url      = aws_ecr_repository.app.repository_url
  })

  tags = { Name = "devops-ansible-controller" }
}
