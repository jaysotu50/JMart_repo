# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "jmart-terraform-remote-state"
    key       = "JM-solution.tfstate"
    region    = "us-east-1"
    profile   = "default"
  }
}