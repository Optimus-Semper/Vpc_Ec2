terraform {
  backend "s3" {
    bucket = "wk6-rev*****"
    key = "VPC-25/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "ter*****"
    encrypt = true
  }
}