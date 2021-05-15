output "lb_name" {
  description = "Name of the Load Balancer"
  value       = azurerm_lb.lb.name
}

output "lb_id" {
  description = "Id of the Load Balancer"
  value       = azurerm_lb.lb.id
}

output "lb_private_ip_address" {
  description = "Private IP address of the Load Balancer"
  value       = azurerm_lb.lb.private_ip_address
}

output "lb_private_ip_addresses" {
  description = "Private IP addresses of the Load Balancer"
  value       = azurerm_lb.lb.private_ip_addresses
}

output "backend_address_pool_id" {
  description = "Id of the associated default backend address pool"
  value       = azurerm_lb_backend_address_pool.default_pool.id
}

output "backend_address_pool_name" {
  description = "Name of the associated default backend address pool"
  value       = azurerm_lb_backend_address_pool.default_pool.name
}

output "backend_address_pool_ip_configurations" {
  description = "IP configurations of the associated default backend address pool"
  value       = azurerm_lb_backend_address_pool.default_pool.backend_ip_configurations
}

output "backend_address_pool_load_balancing_rules" {
  description = "Load balancing rules of the associated default backend address pool"
  value       = azurerm_lb_backend_address_pool.default_pool.load_balancing_rules
}

output "lb_rule_id" {
  description = "Id of the load balancer rules if any"
  value = tomap({
    for k, v in azurerm_lb_rule.lb_rule : k => v.id
  }
}

output "lb_probe_ids" {
  description = "Ids of the load balancer probe if any"
  value = tomap({
    for k, v in azurerm_lb_probe.lb_rule : k => v.id
  }
}
