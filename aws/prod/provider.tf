provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "teste-esg"

  default_tags {
    tags = {

      managed-by  = "terraform"
      Environment = "Producao"
    }
  }
}