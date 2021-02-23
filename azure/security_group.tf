# Control the flow of network traffic in and out of the VM.
resource "azurerm_network_security_group" "opencti_network_security_group" {
  name                = "opencti_network_security_group"
  location            = var.location
  resource_group_name = azurerm_resource_group.opencti_rg.name

  # Allow SSH on port 22
  security_rule {
    name                       = "SSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow access to application on port 4000
  security_rule {
    name                       = "opencti_app_inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "4000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "OpenCTI environment"
  }
}
