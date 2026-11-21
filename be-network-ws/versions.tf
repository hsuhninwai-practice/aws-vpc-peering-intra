terraform {
  required_version = ">= 1.16.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.69.1"
    }
  }

  cloud {
    organization = "CIE_2026"
    workspaces {
      name = "be-network-ws"
    }
  }
}


