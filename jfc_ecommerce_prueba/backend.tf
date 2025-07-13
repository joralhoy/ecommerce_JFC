terraform {
  backend "s3" {
    bucket = "afj-tfstate"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}