

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  depends_on          = [var.module_depends_on]
  address_space = var.vnet_address_space

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "subnet" {
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  for_each = var.subnets

  name              = each.key
  address_prefixes  = flatten([each.value])
}
