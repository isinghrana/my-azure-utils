
resource "azurerm_sql_server" "sqlsrv" {
  name                         = "${var.prefix}sqlsrv"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_username
  administrator_login_password = var.sql_password 
}

resource "azurerm_sql_active_directory_administrator" "sqlsrvadadmin" {
  server_name         = azurerm_sql_server.sqlsrv.name
  resource_group_name = azurerm_resource_group.rg.name
  login               = "Inder Rana"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  depends_on = [ azurerm_sql_server.sqlsrv ]
}

resource "azurerm_sql_database" "ambaridb" {
  name                =  "${var.prefix}ambarisql"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sqlsrv.name
  edition             = "Standard" 
  requested_service_objective_name = "S1"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-dns" {
  name                = "hdi-mgmt-dns"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "168.63.129.16"
  end_ip_address      = "168.63.129.16"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-allregion1" {
  name                = "hdi-mgmt-allregion1"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "168.61.49.99"
  end_ip_address      = "168.61.49.99"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-allregion2" {
  name                = "hdi-mgmt-allregion2"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "23.99.5.239"
  end_ip_address      = "23.99.5.239"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-allregion3" {
  name                = "hdi-mgmt-allregion3"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "168.61.48.131"
  end_ip_address      = "168.61.48.131"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-allregion4" {
  name                = "hdi-mgmt-allregion4"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "138.91.141.162"
  end_ip_address      = "138.91.141.162"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-eastus1" {
  name                = "hdi-mgmt-eastus1"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "13.82.225.233"
  end_ip_address      = "13.82.225.233"
}

resource "azurerm_sql_firewall_rule" "hdi-mgmt-eastus2" {
  name                = "hdi-mgmt-eastus2"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "40.71.175.99"
  end_ip_address      = "40.71.175.99"
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "allow-hdi-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  subnet_id           = data.azurerm_subnet.hdi_subnet.id
}