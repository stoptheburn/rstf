resource "azurerm_virtual_network" "hubNetwork" {
  name                  = "hubNetwork"
  location              = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name   = azurerm_resource_group.rg-hub2spoke.name
  address_space         = ["10.0.0.0/16"]
  
}


resource "azurerm_subnet" "hubSubnet" {
  name = "hubSubnet"
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  virtual_network_name = azurerm_virtual_network.hubNetwork.name
  address_prefixes = ["10.0.0.0/24"]
}