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

# Optional: keep for reference only, not for default assignment
# locals can’t be used as variable defaults
# locals {
#   timestamp_suffix = formatdate("YYYYMMDDHHmmss", timestamp())
# }

# The suffix will be passed from GitHub Actions via -var="suffix=..."
variable "suffix" {
  description = "Unique identifier for this deployment (e.g., GitHub run ID or timestamp)"
  type        = string
  default     = "" # empty by default; overridden in pipeline
}
