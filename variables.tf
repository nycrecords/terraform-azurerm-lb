variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Virtual Network Resource group name"
  type        = string
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "frontend_subnet_name" {
  description = "Name for the subnet where the load balancer frontend ip is deployed".
  type = string
}

variable "sku_name" {
  description = "The Name of the SKU used for this Load Balancer. Possible values are \"Basic\" and \"Standard\"."
  type        = string
  default     = "Standard"
}

variable "extra_tags" {
  description = "Extra tags to add on all resources."
  type        = map(string)
  default     = {}
}

variable "lb_extra_tags" {
  description = "Extra tags to add to the Load Balancer."
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "lb_custom_name" {
  description = "Name of the Load Balancer, generated if not set."
  type        = string
  default     = ""
}

variable "lb_frontend_ip_configurations" {
  description = "`frontend_ip_configuration` blocks as documented here: https://www.terraform.io/docs/providers/azurerm/r/lb.html#frontend_ip_configuration"
  type        = map(any)
  default     = {}
}

variable "lb_rules" {
  description = "`lb_rules` blocks as documented here: https://www.terraform.io/docs/providers/azurerm/r/lb_rule"
  type        = map(any)
  default     = {}
}

variable "lb_probes" {
  description = "`lb_probes` blocks as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe"
  type        = map(any)
  default     = {}
}
