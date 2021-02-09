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
  # This size is:
  # {
  #   "maxDataDiskCount": 4,
  #   "memoryInMb": 3584,
  #   "name": "Standard_DS1_v2",
  #   "numberOfCores": 1,
  #   "osDiskSizeInMb": 1047552,
  #   "resourceDiskSizeInMb": 7168
  # }
  instance_type                  = "Standard_DS1_v2"
}
