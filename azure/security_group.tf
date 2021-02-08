# Control the flow of network traffic in and out of the VM.
resource "azurerm_network_security_group" "opencti_network_security_group" {
  name                = "opencti_network_security_group"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.opencti_rg.name

  # Allow SSH on port 22
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "OpenCTI environment"
  }
}
