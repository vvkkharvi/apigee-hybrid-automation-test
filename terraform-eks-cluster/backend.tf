terraform {
  backend "s3" {
    bucket = "apigee-hybrid-prod"
    key    = "terraform/apigee.tfstate"
    region = "ap-south-1"
  }
}
