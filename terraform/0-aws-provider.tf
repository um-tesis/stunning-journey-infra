provider "aws" {
  profile = "fer-libera"  # Create this profile in your environment with aws configure --profile (region = us-east-1 & output = json)
  region = "us-east-1"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }

  required_version = "~> 1.0"
}
