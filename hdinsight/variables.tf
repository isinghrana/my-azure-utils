/*

Default are setup are get you started creating the entire enviroment with much changes except following 
variables will need to be specified:
- prefix
- vm_password
- sql_aadlogin_name (AAD Login Display Name)
- sql_password
- hdi_cluster_password (at least 10 characters)
- hdi_ssh_password (at least 10 characters)
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

variable "allow_hdimgmt_region_ip1" {
  type = string
  default = "13.82.225.233"
}

variable "allow_hdimgmt_region_ip2" {
  type = string
  default = "40.71.175.99"
}

/*
HDI Management IP Addresses documented here - https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-management-ip-addresses
*/