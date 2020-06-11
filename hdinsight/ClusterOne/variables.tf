variable "prefix" {
    type = string
    default = "myhdicls5"
}

variable "sqlsrv" {
    type = string
    default = ""
}

variable "sqlsrv_rg" {
    type = string
    default = "myhdienv-shared-rg"
}

variable "owner_userid" {
  type = string
  default = "0cd5d12b-d692-42fb-af58-3014e32c881b"
}

variable "sql_accountname" {
    type = string
    default = ""    
}

variable "sql_username" {
    type = string
    default = ""    
}

variable "sql_password" {
    type = string    
    default = ""
}

variable "client_ip" {
    type = string
    default = ""  
}

