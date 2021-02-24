terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "opencti_rg" {
  name     = "opencti_rg"
  location = var.location
}

locals {
  # This is an 8x16 node with 80GB SSD. The A series is meant for proof-of-concept work.
  # OpenCTI minimum specs: https://github.com/OpenCTI-Platform/opencti/blob/5ede2579ee3c09c248d2111b483560f07d2f2c18/opencti-documentation/docs/getting-started/requirements.md
  instance_type = "Standard_A8_v2"
}
