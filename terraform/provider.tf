terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "kwesi" # pinned on purpose — this machine's "default" profile has pointed at the wrong account before

  default_tags {
    tags = {
      Project = var.project_name
    }
  }
}
