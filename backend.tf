# Replace USERNAME with your username and rename this file to backend.tf

terraform {
  backend "s3" {
    bucket = "noths-lab-recruitment-terraform"
    key    = "states/silver-bullet/terraform.state"
    region = "eu-west-1"
  }
}
