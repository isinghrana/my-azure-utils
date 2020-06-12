resource "azurerm_user_assigned_identity" "hdi-usermanagedidentity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = var.prefix
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
    ip_rules = ["168.63.129.16", "168.61.49.99", "23.99.5.239","168.61.48.131", "138.91.141.162", "13.82.225.233", "40.71.175.99"]
    virtual_network_subnet_ids = [data.azurerm_subnet.hdi_subnet.id]
  }
}

resource "azurerm_role_assignment" "additional_owner" {
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Owner"
  principal_id         =  var.adminaduser_objectid 

  depends_on = [azurerm_storage_account.stg]
}

resource "azurerm_role_assignment" "stg_auth_hdiuseridentity" {
  scope                = azurerm_storage_account.stg.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.hdi-usermanagedidentity.principal_id
  depends_on = [azurerm_user_assigned_identity.hdi-usermanagedidentity,
                azurerm_storage_account.stg ] 
}
