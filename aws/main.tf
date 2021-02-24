provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

# These variables aren't meant to be changed by the end user.
locals {
  ami_id                         = "ami-0074ee617a234808d" # Ubuntu 20.04 LTS
  instance_type                  = "t3.2xlarge"            # 8x32 with EBS-backed storage
  opencti_bucket_name            = "opencti-storage"
  opencti_dir                    = "/opt/opencti"
  opencti_install_script_name    = "opencti-installer.sh"
  opencti_connectors_script_name = "opencti-connectors.sh"
}
