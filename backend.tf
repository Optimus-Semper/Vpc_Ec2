terraform {
  backend "s3" {
    bucket = "wk6-revision2025-s3-terraform"
    key = "VPC-25/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform2025-lock"
    encrypt = true
  }
}