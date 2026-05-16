terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-127"
    key            = "backend/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "amazona-terraform-lock"
    encrypt        = true
  }
}