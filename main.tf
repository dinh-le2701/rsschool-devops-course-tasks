terraform {
  backend "s3" {
    bucket  = "terraform-test-state-s3-bucket"
    key     = "terraform_task_4.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
