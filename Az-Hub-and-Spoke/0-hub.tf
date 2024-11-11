resource "azurerm_virtual_network" "hubNetwork" {
  name                = "hubNetwork"
  location            = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  address_space       = ["10.0.0.0/16"]

}


resource "azurerm_subnet" "hubSubnet" {
  name                 = "hubSubnet"
  resource_group_name  = azurerm_resource_group.rg-hub2spoke.name
  virtual_network_name = azurerm_virtual_network.hubNetwork.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "hubVmNic" {
  name                = "hubVmNic"
  location            = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hubSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "hubVm" {
  name                = "hubVm"
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  location            = azurerm_resource_group.rg-hub2spoke.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.hubVmNic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
