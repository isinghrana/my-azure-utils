provider "azurerm" {
  /*  version = "~>1.32.0"*/  
    version = "=2.0.0"
    features {}
}

data "azurerm_client_config" "current" {}

#create new resource group
resource "azurerm_resource_group" "rg" {
    name = "myhdienv-shared-rg"
    location = "eastus"
}

