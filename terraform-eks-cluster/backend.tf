terraform {
  backend "s3" {
    bucket = "apigee-hybrid-prod"
    key    = "apigee.tfstate"
    region = "ap-south-1"
  }
}