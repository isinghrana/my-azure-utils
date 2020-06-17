provider "azurerm" {  
    version = "=2.1.0"
    features {}
}

provider "random" {
 version = "~> 2.2"
}

data "azurerm_client_config" "current" {}

#create new resource group
resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = var.location
}


