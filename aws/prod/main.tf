terraform {
  backend "s3" {
    bucket         = "teste-esg-terraform-tfstate"
    key            = "states/aws/prod/terraform.tfstate"
    dynamodb_table = "aws-prod-terraform-lock"
    region         = "us-east-1"
    encrypt        = true

  }

  required_version = ">= 1.4.5"
}