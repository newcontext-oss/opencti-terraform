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
  name     = "OpenCTI"
  location = "East US"
}

locals {
  opencti_install_email          = "login.email@example.com"
  opencti_install_script_name    = "opencti-installer.sh"
  opencti_connectors_script_name = "opencti-connectors.sh"
  instance_type                  = "Standard_DS1_v2"
}
