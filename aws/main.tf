provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

# Store Terraform state in S3
terraform {
  backend "s3" {
    # The bucket name is a variable defined in `terraform.tfvars` (as `storage_bucket`), but variables are not allowed in this block. If you change this, you will need to change that.
    bucket = "opencti-storage"
    key    = "terraform.tfstate"
    # Again, no variable interpolation in this block so make sure this matches the region defined in `terraform.tfvars`. Default `us-east-1`.
    region = "us-east-1"
  }
}

# These variables aren't meant to be changed by the end user.
locals {
  ami_id                         = "ami-0074ee617a234808d" # Ubuntu 20.04 LTS
  opencti_dir                    = "/opt/opencti"
  opencti_install_script_name    = "opencti-installer.sh"
  opencti_connectors_script_name = "opencti-connectors.sh"
}
