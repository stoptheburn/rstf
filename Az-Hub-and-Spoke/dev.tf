resource "azurerm_virtual_network" "devNetwork" {
  name                  = "devNetwork"
  location              = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name   = azurerm_resource_group.rg-hub2spoke.name
  address_space         = ["10.1.0.0/16"]
  
}

resource "azurerm_subnet" "devSubnet" {
  name = "devSubnet"
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  virtual_network_name = azurerm_virtual_network.devNetwork.name
  address_prefixes = ["10.0.1.0/24"]
}