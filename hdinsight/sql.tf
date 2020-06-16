
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
  login               = var.sqladmin_aadlogin_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  depends_on = [ azurerm_sql_server.sqlsrv ]
}

resource "azurerm_sql_database" "ambaridb" {
  name                =  "${var.prefix}ambarisqldb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sqlsrv.name
  edition             = var.sqldb_edition
  requested_service_objective_name = var.sqldb_level
}

resource "azurerm_sql_firewall_rule" "hdimgmt-region-iprange1" {
  name                = "hdimgmt-region-iprange1"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = var.allow_hdimgmt_region_ip1
  end_ip_address      = var.allow_hdimgmt_region_ip1
}

resource "azurerm_sql_firewall_rule" "hdimgmt-region-iprange2" {
  name                = "hdimgmt-region-iprange2"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = var.allow_hdimgmt_region_ip2
  end_ip_address      = var.allow_hdimgmt_region_ip2
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "allow-hdi-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlsrv.name
  subnet_id           = azurerm_subnet.hdi-subnet.id
}