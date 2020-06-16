resource "random_uuid" "hdi-deploymentid" { }
  
resource "azurerm_resource_group" "hdirg" {
    name = "${var.prefix}-hdi-rg"
    location = var.location
}

resource "azurerm_template_deployment" "hdi" {
  name                = "${var.prefix}hdideploy-${random_uuid.hdi-deploymentid.result}"
  resource_group_name = azurerm_resource_group.hdirg.name
  template_body = file("./hdi-armresources/template.json")
  parameters = {
      "clusterName" = "${var.prefix}hdi"
      "clusterLoginUserName" = var.hdi_cluster_username
      "clusterLoginPassword" = var.hdi_cluster_password
      "sshUserName" = var.hdi_ssh_username    
      "sshPassword" =  var.hdi_ssh_password
      "existingSQLServerResourceGroup" = "${var.prefix}-rg"
      "existingSQLServerName" = "${var.prefix}sqlsrv"
      "existingSQLServerUsername" = var.sql_username
      "existingSQLServerPassword" = var.sql_password
      "existingAmbariSqlDBName" = "${var.prefix}ambarisqldb"
      "existingVirtualNetworkResourceGroup" = "${var.prefix}-rg"
      "existingVirtualNetworkName" =  "${var.prefix}-vnet"
      "existingVirtualNetworkSubnetName" = "hdi-subnet"
      "existingAdlsGen2StgAccountResourceGroup" = "${var.prefix}-rg"
      "existingAdlsGen2StgAccountname" = "${var.prefix}stg"
      "newOrExistingAdlsGen2FileSystem" = "${var.prefix}fs"
      "existingHdiUserManagedIdentityResourceGroup" = "${var.prefix}-rg"
      "existingHdiUserManagedIdentityName" = "${var.prefix}hdiumi"
   }
  deployment_mode = "Incremental"
  depends_on =   [
    azurerm_sql_virtual_network_rule.sqlvnetrule,
    azurerm_sql_firewall_rule.hdimgmt-region-iprange1,
    azurerm_sql_firewall_rule.hdimgmt-region-iprange2,
    azurerm_sql_database.ambaridb,
    azurerm_role_assignment.stg_auth_hdiuseridentity,
    azurerm_subnet_network_security_group_association.hdi-subnet-nsg-association,
    azurerm_network_security_rule.AllowHDIManagement1,
    azurerm_network_security_rule.AllowHDIManagement2,
    azurerm_virtual_network.vnet,
    azurerm_subnet.hdi-subnet
  ]
}
