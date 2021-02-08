# Create private key and output it to console.
resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" { value = tls_private_key.ssh_private_key.private_key_pem }

# Create Ubuntu virtual machine and attach it to the virtual NIC.
resource "azurerm_linux_virtual_machine" "opencti_vm" {
  name                  = "OpenCTI virtual machine"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.opencti_rg.name
  network_interface_ids = [azurerm_network_interface.opencti_nic.id]
  size                  = local.instance_type

  os_disk {
    name                 = "os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  computer_name                   = "opencti_vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_private_key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.opencti_storage.primary_blob_endpoint
  }

  tags = {
    environment = "OpenCTI environment"
  }
}
