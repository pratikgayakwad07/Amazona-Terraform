terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-127"
    key            = "backend/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   =  true
  }
}
