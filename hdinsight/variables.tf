/*

Default are setup are get you started creating the entire enviroment with much changes except following 
variables will need to be specified:
- prefix
- vm_password
- sql_aadlogin_name (AAD Login Display Name)
- sql_password
- hdi_cluster_password (at least 10 characters)
- hdi_ssh_password (at least 10 characters)
- external_client_iprange
*/

variable "location" {
    type = string
    default = "eastus"
}

variable "prefix" {
    type = string
    default = ""
}

variable "vm_username" {
  type = string
  default = "hdivmuser"
}

variable "vm_password" {
  type = string
  default = ""
}

variable "vm_size" {
  type = string
  default = "Standard_DS2"
}

variable "sqladmin_aadlogin_name" {
  type = string
  default = ""
  description = "Display name of the user account in Azure AD "
}
variable "sql_username" {
    type = string
    default = "mysqladmin"    
}

variable "sql_password" {
    type = string    
    default = ""
}

variable "sqldb_edition" {
  type = string
  default = "Standard"
}

variable "sqldb_level" {
  type = string
  default = "S1"
}

variable "hdi_cluster_username" {
  type = string
  default = "myhdiuser"
}

variable "hdi_cluster_password" {
  type = string
  default = ""
}

variable "hdi_ssh_username" {
  type = string
  default = "sshuser"
}

variable "hdi_ssh_password" {
  type = string
  default = ""
}

/* 
   vnet_iprange and subnet ip ranges are Private IP Ranges so you can pick any values for these you like
   Usually 172.16.0.0/12, 192.168.0.0/16 and 10.0.0.0/8 are used as the private IP Ranges
   https://www.arin.net/reference/research/statistics/address_filters/
*/

variable "vnet_iprange" {
  type = string
  default = "172.16.0.0/19"
}

variable "hdi_subnet_iprange" {
  type = string
  default = "172.16.0.0/21"
}

variable "vm_subnet_iprange" {
  type = string
  default = "172.16.8.0/26"
}

variable "bastion_subnet_iprange" {
  type = string
  default = "172.16.8.64/26"
}

/*
  When HDInsight clusters are created in customer a handful IP addresses owned by Microsoft Azure
  need to be allowed to communicate with the cluster for managemenet purpose. There are documented here -
  - https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-management-ip-addresses  
  Default Values for the two hdimgmt variables are of East US
*/
variable "allow_hdimgmt_region_ip1" {
  type = string
  default = "13.82.225.233"
}

variable "allow_hdimgmt_region_ip2" {
  type = string
  default = "40.71.175.99"
}

variable "external_client_iprange" {
  /*
    Update as per your environment - If connecting from corporate networks this would be a set of CIDR Ranges,
    if you are just trying out provisioning and don't have the exact ranges just go to https://whatismyip.com then use the following scheme
    to set value. Say, if it shows 173.25.66.22 then set the value to 173.25.0.0/16 

    In corporate environments, most likely there will be a handuful of IP Ranges so variables of similar nature
    will need to be added as well as corresponding changes made to the tf files storage.tf and vnet.tf (Bastion Subnet and HDI Subnet) 
    */
  type = string
  default = "" 
  description = "This is CIDR range of the client outside Azure from where you want to connect to Azure Bastion, Azure Storage Account or Azure HDInsight Ambari Web UI"
}
