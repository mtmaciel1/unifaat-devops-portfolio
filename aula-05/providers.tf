terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "technova-terraform-state-yvk12es2"
    key            = "aula-05/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "technova-terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "TechNova"
      Aula    = "05"
    }
  }
}