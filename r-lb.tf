data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  name = var.frontend_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_lb" "lb" {
  location            = var.location
  name                = local.lb_name
  resource_group_name = data.azurerm_resource_group.rg.name

  sku = var.sku_name

  dynamic "frontend_ip_configuration" {
    for_each = var.lb_frontend_ip_configurations
    content {
      name = frontend_ip_configuration.key

      subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", "Dynamic")
      zones                         = tolist(lookup(frontend_ip_configuration.value, "zones", null))
    }
  }
  #      private_ip_address_version    = lookup(each.value, "private_ip_address_version", "IPv4")

  tags = merge(local.default_tags, var.extra_tags, var.lb_extra_tags)
}

resource "azurerm_lb_backend_address_pool" "default_pool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "defautlBackendAddressPool"
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each = var.lb_rules
  content {
      name = each.key

      resource_group_name = data.azurerm_resource_group.rg.name
      loadbalancer_id = azurerm_lb.lb.id
      
      frontend_ip_configuration_name = lookup(each.value, "frontend_ip_configuration_names")
      probe_id = lookup(each.value, "probe_id")
      protocol = lookup(each.value, "protocol")
      frontend_port = lookup(each.value, "frontend_port")
      backend_port = lookup(each.value, "backend_port")
    }
}

resource "azurerm_lb_probe" "lb_probe" {
  for_each = var.lb_probes
  content {
      name = each.key

      resource_group_name = data.azurerm_resource_group.rg.name
      loadbalancer_id = azurerm_lb.lb.id
      
      protocol = lookup(each.value, "protocol")
      port = lookup(each.value, "port")
      interval_in_seconds = lookup(each.value, "probe_interval", 15)
      number_of_probes = lookup(each.value, "num_probes", 2)
      request_path = lookup(each.value, "request_path")
    }
}
