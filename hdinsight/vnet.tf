resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [ var.vnet_iprange ]
}

/* Subnet List */

resource "azurerm_subnet" "hdi-subnet" {
  name                 = "hdi-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.hdi_subnet_iprange
  service_endpoints =  ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.vm_subnet_iprange
  service_endpoints =  ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "azure-bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.bastion_subnet_iprange
  service_endpoints =  ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}

/* HDI Subnet NSG */

resource "azurerm_network_security_group" "hdi-subnet-nsg" {
  name = "${var.prefix}-hdi-subnet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name  
}

resource "azurerm_subnet_network_security_group_association" "hdi-subnet-nsg-association" {
  subnet_id       = azurerm_subnet.hdi-subnet.id
  network_security_group_id = azurerm_network_security_group.hdi-subnet-nsg.id
}

resource "azurerm_network_security_rule" "AllowHDIManagement1" {
  name                        = "AllowHDIManagement1"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "${var.allow_hdimgmt_region_ip1}/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.hdi-subnet-nsg.name
}

resource "azurerm_network_security_rule" "AllowHDIManagement2" {
  name                        = "AllowHDIManagement2"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "${var.allow_hdimgmt_region_ip2}/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.hdi-subnet-nsg.name
}

resource "azurerm_network_security_rule" "hdi-external-in-allow" {
  name                        = "hdi-externalclient-in-allow"
  priority                    = 1200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.external_client_iprange
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.hdi-subnet-nsg.name
}


/*VM Subnet NSG */
resource "azurerm_network_security_group" "vm-subnet-nsg" {
  name = "${var.prefix}-vm-subnet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name  
}

resource "azurerm_subnet_network_security_group_association" "vm-subnet-nsg-association" {
  subnet_id       = azurerm_subnet.vm-subnet.id
  network_security_group_id = azurerm_network_security_group.vm-subnet-nsg.id
}


/*Bastion Subnet NSG */
resource "azurerm_network_security_group" "azure-bastion-subnet-nsg" {
  name = "${var.prefix}-azure-bastion-subnet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name  
}


resource "azurerm_subnet_network_security_group_association" "azure-bastion-subnet-nsg-association" {
  subnet_id       = azurerm_subnet.azure-bastion-subnet.id
  network_security_group_id = azurerm_network_security_group.azure-bastion-subnet-nsg.id  
  depends_on = [
                 azurerm_network_security_rule.bastion-control-in-allow,
                 azurerm_network_security_rule.bastion-vnet-out-allow,
                 azurerm_network_security_rule.bastion-azure-out-allow
                ]
}

resource "azurerm_network_security_rule" "bastion-control-in-allow" {
  name                        = "bastion-control-in-allow"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.azure-bastion-subnet-nsg.name
}

resource "azurerm_network_security_rule" "bastion-vnet-out-allow" {
  name                        = "bastion-vnet-out-allow"
  priority                    = 1100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["22" ,"3389"]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.azure-bastion-subnet-nsg.name
}

resource "azurerm_network_security_rule" "bastion-azure-out-allow" {
  name                        = "bastion-azure-out-allow"
  priority                    = 1200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.azure-bastion-subnet-nsg.name
}

resource "azurerm_network_security_rule" "bastion-externalclient-in-allow" {
  name                        = "bastion-externalclient-in-allow"
  priority                    = 1300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.external_client_iprange
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.azure-bastion-subnet-nsg.name
}
