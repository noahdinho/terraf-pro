terraform {
  backend "s3" {
    bucket         = "terraform-nick-w7"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "locktab"
  }
}