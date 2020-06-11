provider "azurerm" {
  /*  version = "~>1.32.0"*/  
    version = "=2.1.0"
    features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_subnet" "hdi_subnet" {
  name                 = "hdi-subnet"
  virtual_network_name = "hdi-shared-vnet"
  resource_group_name  = "myhdienv-shared-rg"
}

#create new resource group
resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = "eastus"
}


