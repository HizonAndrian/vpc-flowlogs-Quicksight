terraform {

  required_version = "~> 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  cloud {

    organization = "Projects_and_deliverables"

    workspaces {
      name = "vpc-flowlogs-Quicksight"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}