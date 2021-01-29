provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/path/to/aws/credentials"
  profile                 = "default"
}

locals {
  # Ubuntu 20.04 LTS
  ami_id = "ami-0074ee617a234808d"

  opencti_bucket_name            = "opencti-storage"
  opencti_install_email          = "admin@example.com"
  opencti_install_script_name    = "opencti-installer.sh"
  opencti_connectors_script_name = "opencti-connectors.sh"
  vpc_id                         = ""
  subnet_id                      = ""
  instance_type                  = "t3.medium"
}
