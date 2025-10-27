terraform {
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

# Generate unique suffix per deployment (based on timestamp)
locals {
  timestamp_suffix = formatdate("YYYYMMDDHHmmss", timestamp())
}

variable "suffix" {
  description = "Unique identifier for resources (e.g., timestamp or GitHub run ID)"
  default     = local.timestamp_suffix
}
