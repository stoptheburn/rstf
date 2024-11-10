resource "azurerm_virtual_network" "testNetwork" {
  name                  = "testNetwork"
  location              = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name   = azurerm_resource_group.rg-hub2spoke.name
  address_space         = ["10.2.0.0/16"]
  
}

resource "azurerm_subnet" "testSubnet" {
  name = "testSubnet"
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  virtual_network_name = azurerm_virtual_network.testNetwork.name
  address_prefixes = ["10.0.2.0/24"]
}
