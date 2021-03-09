# Create private key and output it to the console.
resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" { value = tls_private_key.ssh_private_key.private_key_pem }

# Bootstrap deployment with wrapper script.
data "template_file" "wrapper_script" {
  template = file("../userdata/installation-wrapper-script.sh")
  # The wrapper script is used by each of the providers and each variable has to be filled out in order to run. Unfortunately, this means that if you change something in one provider, you have to change it in each of the others. It's not ideal, but FYI.
  vars = {
    "account_name"           = var.account_name
    "cloud"                  = "azure"
    "connection_string"      = azurerm_storage_account.opencti_storage.primary_connection_string
    "connectors_script_name" = "opencti-connectors.sh"
    "install_script_name"    = "opencti-installer.sh"
    "login_email"            = var.login_email
    "storage_bucket"         = azurerm_storage_container.opencti-storage-container.name
  }
}

# Create Ubuntu virtual machine and attach it to the virtual NIC.
resource "azurerm_linux_virtual_machine" "opencti_vm" {
  name                  = "opencti"
  location              = azurerm_resource_group.opencti_rg.location
  resource_group_name   = azurerm_resource_group.opencti_rg.name
  network_interface_ids = [azurerm_network_interface.opencti_nic.id]
  size                  = local.instance_type
  admin_username        = var.admin_user
  custom_data           = base64encode(data.template_file.wrapper_script.rendered)

  os_disk {
    name                 = "os_disk"
    caching              = "ReadWrite"
    disk_size_gb         = var.os_disk_size
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu 20.04 LTS
  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_user
    public_key = tls_private_key.ssh_private_key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.opencti_storage.primary_blob_endpoint
  }

  tags = {
    environment = "OpenCTI virtual machine"
  }
}
