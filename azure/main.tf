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
  location               = "eastus"
  # This instance size is:
  # {
  #   "maxDataDiskCount": 4,
  #   "memoryInMb": 4096,
  #   "name": "Standard_A2_v2",
  #   "numberOfCores": 2,
  #   "osDiskSizeInMb": 1047552,
  #   "resourceDiskSizeInMb": 20480
  # }
  # To see other sizes, run `az vm list-sizes --location <location>`
  instance_type = "Standard_A2_v2"
}
