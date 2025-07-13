provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "afj-tfstate"
}