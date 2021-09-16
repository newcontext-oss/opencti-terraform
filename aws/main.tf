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

data "aws_ami" "ubuntu_server" {
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210119.1"]
  }
}

# These variables aren't meant to be changed by the end user.
locals {
  ami_id                         = data.aws_ami.ubuntu_server.id
  opencti_dir                    = "/opt/opencti"
  opencti_install_script_name    = "opencti-installer.sh"
  opencti_connectors_script_name = "opencti-connectors.sh"
}
