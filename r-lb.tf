data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.frontend_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.vnet_resource_group_name
}

resource "azurerm_lb" "lb" {
  location            = local.location
  name                = local.lb_name
  resource_group_name = data.azurerm_resource_group.rg.name

  sku = var.sku_name

  dynamic "frontend_ip_configuration" {
    for_each = var.lb_frontend_ip_configurations
    content {
      name = frontend_ip_configuration.key

      subnet_id                     = data.azurerm_subnet.subnet.id
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", "Dynamic")
      zones                         = tolist(lookup(frontend_ip_configuration.value, "zones", null))
    }
  }
  #      private_ip_address_version    = lookup(each.value, "private_ip_address_version", "IPv4")

  tags = merge(local.default_tags, var.extra_tags, var.lb_extra_tags)
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each = var.lb_rules
  name     = each.key

  loadbalancer_id     = azurerm_lb.lb.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.default_pool.id]

  frontend_ip_configuration_name = lookup(each.value, "frontend_ip_configuration_name")
  probe_id                       = "${azurerm_lb.lb.id}/probes/${lookup(each.value, "probe_id")}"
  protocol                       = lookup(each.value, "protocol")
  frontend_port                  = lookup(each.value, "frontend_port")
  backend_port                   = lookup(each.value, "backend_port")
}

resource "azurerm_lb_probe" "lb_probe" {
  for_each = var.lb_probes
  name     = each.key

  loadbalancer_id     = azurerm_lb.lb.id

  protocol            = lookup(each.value, "protocol")
  port                = lookup(each.value, "port")
  interval_in_seconds = lookup(each.value, "probe_interval", 15)
  number_of_probes    = lookup(each.value, "num_probes", 2)
  request_path        = lookup(each.value, "request_path")
}

resource "azurerm_lb_backend_address_pool" "default_pool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "defaultBackendAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "backend_pool_address" {
  for_each = var.backend_pool_addresses

  name                    = each.key
  backend_address_pool_id = azurerm_lb_backend_address_pool.default_pool.id
  virtual_network_id      = data.azurerm_virtual_network.vnet.id
  ip_address              = lookup(each.value, "ip_address")
}
