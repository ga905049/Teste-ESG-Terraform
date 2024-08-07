provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {

      managed-by  = "terraform"
      Environment = "Producao"
    }
  }
}