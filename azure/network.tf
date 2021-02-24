# Create virtual network that everything is going to live in.
resource "azurerm_virtual_network" "opencti_virtual_network" {
  name                = "opencti_virtual_network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.opencti_rg.location
  resource_group_name = azurerm_resource_group.opencti_rg.name

  tags = {
    environment = "OpenCTI virtual network"
  }
}

# Create subnet inside OpenCTI virtual network.
resource "azurerm_subnet" "opencti_subnet" {
  name                 = "opencti_subnet"
  resource_group_name  = azurerm_resource_group.opencti_rg.name
  virtual_network_name = azurerm_virtual_network.opencti_virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create public IP so we can access OpenCTI resources externally. The network security group (set up in `security_group.tf`) controls access to the network.
resource "azurerm_public_ip" "opencti_public_ip" {
  name                = "opencti_public_ip"
  location            = azurerm_resource_group.opencti_rg.location
  resource_group_name = azurerm_resource_group.opencti_rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "OpenCTI public IP"
  }
}

# The virtual NIC connects the VM to the virtual network, public IP address, and network security group.
resource "azurerm_network_interface" "opencti_nic" {
  name                = "opencti_nic"
  location            = azurerm_resource_group.opencti_rg.location
  resource_group_name = azurerm_resource_group.opencti_rg.name

  ip_configuration {
    name                          = "opencti_nic_config"
    subnet_id                     = azurerm_subnet.opencti_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.opencti_public_ip.id
  }

  tags = {
    environment = "OpenCTI NIC"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "connect_security_group" {
  network_interface_id      = azurerm_network_interface.opencti_nic.id
  network_security_group_id = azurerm_network_security_group.opencti_network_security_group.id
}
