locals {
  default_tags = {
    env   = var.environment
  }
  
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  lb_name = coalesce(
    var.lb_custom_name,
    "${local.name_prefix}-${var.location_short}-${var.environment}-lb",
  )
}
