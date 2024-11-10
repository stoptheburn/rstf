# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  #subscription_id = var.subscription_id
  #skip_provider_registration = true
}

variable "subid" {
  type = string
}

variable "tenandid" {
  type = string
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  #registry = "registry.terraform.io/hashicorp/azurerm"
  subscription_id = var.subid
  #tenant_id       = var.tenandid
  #skip_provider_registration = false
}

resource "azurerm_resource_group" "rs-rg" {
  name     = "rs-resources"
  location = "East Us"
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "rs-vnet" {
  name                = "rs-network"
  resource_group_name = azurerm_resource_group.rs-rg.name
  location            = azurerm_resource_group.rs-rg.location
  address_space       = ["10.72.0.0/16"]

  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "rs-snet" {
  name                 = "rs-subnet-1"
  resource_group_name  = azurerm_resource_group.rs-rg.name
  virtual_network_name = azurerm_virtual_network.rs-vnet.name
  address_prefixes     = ["10.72.1.0/24"]
}

resource "azurerm_network_security_group" "rs-nsg" {
  name                = "rs-nsg-1"
  resource_group_name = azurerm_resource_group.rs-rg.name
  location            = azurerm_resource_group.rs-rg.location

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_security_rule" "rs-nsg-rule" {
  name                        = "rs-nsg-rule-1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rs-rg.name
  network_security_group_name = azurerm_network_security_group.rs-nsg.name
  #location                   = azurerm_resource_group.rs-rg.location
}

resource "azurerm_subnet_network_security_group_association" "rs-nsg-assoc" {
  subnet_id                 = azurerm_subnet.rs-snet.id
  network_security_group_id = azurerm_network_security_group.rs-nsg.id
}

# public ip - https://www.youtube.com/watch?v=V53AHWun17s - 45:11
#resource "azurerm_public_ip" "rs-pub-ip" {
#  name                = "rs-pub-ip-1"
#  resource_group_name = azurerm_resource_group.rs-rg.name
#  location            = azurerm_resource_group.rs-rg.location
#  allocation_method   = "Dynamic"
#
#  tags = {
#    environment = "test"
#  }
#}

/*
resource "azurerm_network_interface" "rs-nic" {
  name                = "rs-nic-1"
  location            = azurerm_resource_group.rs-rg.location
  resource_group_name = azurerm_resource_group.rs-rg.name

  #ip_configuration {
  #  name                          = "internal"
  #  subnet_id                     = azurerm_subnet.rs-snet.id
  #  private_ip_address_allocation = "Dynamic"
  #}
}*/
