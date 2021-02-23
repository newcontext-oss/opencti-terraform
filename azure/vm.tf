# Create private key and output it to the console.
resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" { value = tls_private_key.ssh_private_key.private_key_pem }

# Bootstrap deployment with wrapper script
data "template_file" "wrapper_script" {
  template = file("../userdata/installation-wrapper-script.sh")
  vars = {
    "account_name"           = "Pay-As-You-Go"
    "bucket_name"            = "only for aws"
    "connection_string"      = azurerm_storage_account.opencti_storage.primary_connection_string
    "connectors_script_name" = "opencti-connectors.sh"
    "container_name"         = azurerm_storage_container.opencti-storage-container.name
    "install_script_name"    = "opencti-installer.sh"
    "login_email"            = "login.email@example.com"
    "provider"               = "azure"
  }
}

# Create Ubuntu virtual machine and attach it to the virtual NIC.
resource "azurerm_linux_virtual_machine" "opencti_vm" {
  name                  = "opencti_vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.opencti_rg.name
  network_interface_ids = [azurerm_network_interface.opencti_nic.id]
  size                  = local.instance_type

  os_disk {
    name                 = "os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" # time of writing: 20.04 not available (2021-02-09)
    version   = "latest"
  }

  computer_name                   = "opencti-vm" # underscores not allowed
  admin_username                  = "azureuser"
  disable_password_authentication = true
  # Run wrapper script
  custom_data = base64encode(data.template_file.wrapper_script.rendered)

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
