# Create storage account. The default storage type is StorageV2: https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
resource "azurerm_storage_account" "opencti_storage" {
  name                     = var.storage_bucket
  resource_group_name      = azurerm_resource_group.opencti_rg.name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "OpenCTI environment"
  }
}

# Create a storage container within the storage account. This is where we will store files.
resource "azurerm_storage_container" "opencti-storage-container" {
  name                  = "opencti-storage-container"
  storage_account_name  = azurerm_storage_account.opencti_storage.name
  container_access_type = "private"
}

# Store the install and connectors scripts in the storage container.
resource "azurerm_storage_blob" "install_script" {
  name                   = "opencti-installer.sh"
  storage_account_name   = azurerm_storage_account.opencti_storage.name
  storage_container_name = azurerm_storage_container.opencti-storage-container.name
  type                   = "Block"
  content_type           = "text/x-shellscript"
  source                 = "../opencti_scripts/installer.sh"
}

resource "azurerm_storage_blob" "connectors_script" {
  name                   = "opencti-connectors.sh"
  storage_account_name   = azurerm_storage_account.opencti_storage.name
  storage_container_name = azurerm_storage_container.opencti-storage-container.name
  type                   = "Block"
  content_type           = "text/x-shellscript"
  source                 = "../opencti_scripts/connectors.sh"
}
