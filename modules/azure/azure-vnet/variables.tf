variable "vnet_name" {
  description = "Name of your Azure Virtual Network"
  default     = "vnet-azure-westeurope-001"
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "rg-demo-westeurope-01"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
}

variable "vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = ["10.0.0.0/16"]
}

variable "module_depends_on" {
  type    = any
  default = null
}

variable "subnets" {
  type        = map(string)
  description = "Map of subnet names to address prefixes. Default: none."
  default     = {}
}