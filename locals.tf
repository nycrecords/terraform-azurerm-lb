module "azure_region" {
  source = "github.com/nycrecords/infrastructure-modules.git//terraform-azurerm-regions/"

  azure_region = var.region
}
locals {
  location_short = module.azure_region.output.location_short
  default_tags = {
    env   = var.environment
  }

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  lb_name = coalesce(
    var.lb_custom_name,
    "${local.name_prefix}-${local.location_short}-${var.environment}-lb",
  )

}
