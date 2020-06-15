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


resource "azurerm_network_security_group" "hdi-nsg" {
  name = "hdi-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule = []
/*
  security_rule =  [{
          name = "AllowHDIManagementEastUS1"
        priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "13.82.225.233/32"
    destination_address_prefix = "*"       
  },
  {
          name = "AllowHDIManagementEastUS2"
        priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "40.71.175.99/32"
    destination_address_prefix = "*"       
  }
  ]
  */
}


resource "azurerm_subnet_network_security_group_association" "hdi-subnet-nsg-association" {
  subnet_id       = azurerm_subnet.hdi-subnet.id
  network_security_group_id = azurerm_network_security_group.hdi-nsg.id
}

resource "azurerm_network_security_rule" "AllowHDIManagementEastUS1" {
  name                        = "AllowHDIManagementEastUS1"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "13.82.225.233/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.hdi-nsg.name
}

resource "azurerm_network_security_rule" "AllowHDIManagementEastUS2" {
  name                        = "AllowHDIManagementEastUS2"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "40.71.175.99/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.hdi-nsg.name
}