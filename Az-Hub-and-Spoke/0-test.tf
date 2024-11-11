resource "azurerm_virtual_network" "testNetwork" {
  name                = "testNetwork"
  location            = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  address_space       = ["10.2.0.0/16"]

}

resource "azurerm_subnet" "testSubnet" {
  name                 = "testSubnet"
  resource_group_name  = azurerm_resource_group.rg-hub2spoke.name
  virtual_network_name = azurerm_virtual_network.testNetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "testVmNic" {
  name                = "testVmNic"
  location            = azurerm_resource_group.rg-hub2spoke.location
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.testSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "testVm" {
  name                = "testVm"
  resource_group_name = azurerm_resource_group.rg-hub2spoke.name
  location            = azurerm_resource_group.rg-hub2spoke.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.testVmNic.id,
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
