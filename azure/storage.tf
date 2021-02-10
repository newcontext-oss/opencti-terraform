# Storage for boot diagnostics.
# Each storage account must have a unique name:
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.opencti_rg.name
  }

  byte_length = 8
}

# Create storage account (the name is based on the above randomId). The default storage type is StorageV2: https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
resource "azurerm_storage_account" "opencti_storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.opencti_rg.name
  location                 = local.location
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
# OpenCTI installer script
resource "azurerm_storage_blob" "install_script" {
  name                   = "opencti-installer.sh"
  storage_account_name   = azurerm_storage_account.opencti_storage.name
  storage_container_name = azurerm_storage_container.opencti-storage-container.name
  type                   = "Block"
  content_type           = "text/x-shellscript"
  source                 = "../opencti_scripts/installer.sh"
}

# OpenCTI connectors script
resource "azurerm_storage_blob" "connectors_script" {
  name                   = "opencti-connectors.sh"
  storage_account_name   = azurerm_storage_account.opencti_storage.name
  storage_container_name = azurerm_storage_container.opencti-storage-container.name
  type                   = "Block"
  content_type           = "text/x-shellscript"
  source                 = "../opencti_scripts/connectors.sh"
}
