terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-127"
    key            = "amazona-app/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   =  true
  }
}
