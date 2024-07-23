terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
    aws = {
      source = "hashicorp/aws"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}

provider "aws" {
  region = var.aws_region
}
