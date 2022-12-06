data "azurerm_client_config" "current" {}

# Deploy hub resource
module azure-resource-group-hub {
  source   = "./modules/azure/azure-resourcegroup"
  resource_group_name     = "HubConnectivity"
  location = "West Europe"
  providers = {
    azurerm  = azurerm.hub_sub
   }
}

module "vnet-hub" {
  source    = "./modules/azure/azure-vnet"
  vnet_name = "customer-hub-vnet"
  depends_on = [
    module.azure-resource-group-hub
  ]
  resource_group_name = module.azure-resource-group-hub.resource_group_name
  vnet_address_space = ["10.0.0.0/16"]
  providers = {
    azurerm  = azurerm.hub_sub
   }
}

# Deploy spoke resources
module azure-resource-group-spoke {
  source   = "./modules/azure/azure-resourcegroup"
  resource_group_name     = "SpokeConnectivity"
  location = "West Europe"
  providers = {
    azurerm  = azurerm.spoke_sub
   }
}

module "vnet-spoke" {
  source    = "./modules/azure/azure-vnet"
  vnet_name = "customer-spoke-vnet"
  depends_on = [
    module.azure-resource-group-spoke
  ]
  resource_group_name = module.azure-resource-group-spoke.resource_group_name
  vnet_address_space = ["172.16.0.0/12"]
  providers = {
    azurerm  = azurerm.spoke_sub
   }
}

locals {  
  policy_map = {
    whitelist_regions = "Whitelist Azure regions"
    #require_resource_group_tags = "Require resource group tags"
  }
}

data "azurerm_management_group" "customer" {
  name = "Customer"
}

#https://github.com/gettek/terraform-azurerm-policy-as-code

# To define new policy at Management group level

# module whitelist_regions {
#   source              = "./modules/policies/definition"
#   policy_name         = "whitelist_regions"
#   display_name        = "Allow resources only in whitelisted regions"
#   policy_category     = "general"
#   management_group_id = data.azurerm_management_group.sandoz.id
# }


# Sample code to create policy definition dynamically
# module "configure_general_policy" {
#   source                = "./modules/policies/definition"
#   for_each              = local.policy_map
#   policy_name           = each.key
#   display_name          = title(replace(each.key, "_", " "))
#   policy_description    = each.value
#   policy_category       = "general"
#   management_group_id   = data.azurerm_management_group.sandoz.id
# }


# module global_whitelist_regions {
#   source            = "./modules/policies/def_assignment"
#   definition        = module.whitelist_regions.definition
#   assignment_scope  = data.azurerm_management_group.sandoz.id
#   assignment_effect = "Deny"

#   assignment_parameters = {
#     "listOfRegionsAllowed" = [
#       "West Europe"
#     ]
#   }
# }

resource "azurerm_management_group_policy_assignment" "Allowed_Locations" {
  name = "Allowed locations"
  display_name = "Allowed locations"
  management_group_id  = data.azurerm_management_group.customer.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"  
  parameters = jsonencode({
    listOfAllowedLocations= { value= ["westeurope"]}
  })
}