terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.34.0"
       configuration_aliases = [
        azurerm.hub_sub,
        azurerm.spoke_sub,
      ]
    }
  }
}

 provider "azurerm"  {
   features {}
   subscription_id = var.hub_sub_id
  }

provider "azurerm" {
  alias = "hub_sub"
  subscription_id = var.hub_sub_id
  features {}
}

provider "azurerm" {
  alias = "spoke_sub"
  subscription_id = var.spoke_sub_id
  features {}
}
