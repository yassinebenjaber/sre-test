terraform {
  backend "s3" {
    bucket  = "order-system-terraform-state" # static name
    key     = "state/terraform.tfstate"      # single consistent file
    region  = "eu-north-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}
