resource "azurerm_user_assigned_identity" "hdi-usermanagedidentity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = "${var.prefix}hdiumi"
}

resource "azurerm_storage_account" "stg" {
  name                     = "${var.prefix}stg"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  network_rules {
    default_action = "Deny"
    ip_rules = [var.allow_hdimgmt_region_ip1, 
                var.allow_hdimgmt_region_ip2, 
                var.external_client_iprange]
    virtual_network_subnet_ids = [ azurerm_subnet.vm-subnet.id, azurerm_subnet.hdi-subnet.id ]
  }
}
/*
resource "azurerm_role_assignment" "additional_owner" {
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Owner"
  principal_id         =  data.azurerm_client_config.current.object_id  
}
*/

resource "azurerm_role_assignment" "stg_auth_hdiuseridentity" {
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.hdi-usermanagedidentity.principal_id  
}
