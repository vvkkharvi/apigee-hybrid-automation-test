terraform {
  backend "s3" {
    bucket = "apigee-hybrid-prod"
     key   = "terraform-state/apigee.tfstate"
    region = "ap-south-1"
  }
}
