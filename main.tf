provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/path/to/your/.aws/credentials"
  profile                 = "default"
}

locals {
  # Ubuntu 20.04 LTS
  ami_id = "ami-0074ee617a234808d"

  opencti_bucket_name            = "opencti-storage"
  opencti_install_email          = "login.email@example.com"
  opencti_install_script_name    = "opencti-installer.sh"
  opencti_connectors_script_name = "opencti-connectors.sh"
  vpc_id                         = "vpc-FILLTHISIN"
  subnet_id                      = "subnet-FILLTHISIN"
  instance_type                  = "t3.medium"
}
