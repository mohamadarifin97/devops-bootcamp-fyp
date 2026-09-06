terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Bucket ini perlu wujud dahulu (buat manual sekali sahaja):
  #   aws s3api create-bucket --bucket devops-bootcamp-terraform-arifin \
  #     --region ap-southeast-1 \
  #     --create-bucket-configuration LocationConstraint=ap-southeast-1
  backend "s3" {
    bucket       = "devops-bootcamp-terraform-arifin"
    key          = "fyp/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_caller_identity" "current" {}

locals {
  nama = "arifin"
}
