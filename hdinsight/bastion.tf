/*Bastion Host*/

resource "azurerm_public_ip" "bastion-publicip" {
  name                = "${var.prefix}bastionpubip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.prefix}bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azure-bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-publicip.id
  }
}