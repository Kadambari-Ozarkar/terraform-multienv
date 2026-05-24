terraform {
  backend "s3" {

    bucket = "terraform-multi-env-s3"

    key    = "multi-env/terraform.tfstate"

    region = "eu-north-1"
  }
}