# Storage for boot diagnostics.
# Each storage account must have a unique name:
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.opencti_rg.name
  }

  byte_length = 8
}

# Create storage account (the name is based on the above randomId)
resource "azurerm_storage_account" "opencti_storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.opencti_rg.name
  location                 = "eastus"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "OpenCTI environment"
  }
}
