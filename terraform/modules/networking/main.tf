resource "azurerm_virtual_network" "vnet" {
  name                = "ticktra-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "default-subnet"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "aks-subnet"
    address_prefixes = ["10.0.2.0/24"]
  }

}