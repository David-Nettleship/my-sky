terraform {
  backend "s3" {
    bucket  = "terraform-state-304707804854"
    key     = "my-sky/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}
