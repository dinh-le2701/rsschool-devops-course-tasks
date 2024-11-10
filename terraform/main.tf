terraform {
  backend "s3" {
    bucket = "terraform-test-state-s3-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68"
    }
  }

  backend "s3" {
    bucket = "terraform-test-state-s3-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
