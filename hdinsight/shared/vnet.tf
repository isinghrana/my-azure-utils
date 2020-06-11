resource "azurerm_virtual_network" "vnet" {
  name                = "hdi-shared-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["172.16.0.0/19"]    
}

resource "azurerm_subnet" "hdi-subnet" {
  name                 = "hdi-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "172.16.0.0/21"
  service_endpoints =  ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "172.16.8.0/26"
  service_endpoints =  ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "azure-bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "172.16.8.64/26"
  service_endpoints =  ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}


