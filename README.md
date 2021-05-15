# Azure Load Balancer (L4)
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/lb/azurerm/)

This Terraform module creates an [Azure Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) 
with possible Public IP address and [basic NAT](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-rules-overview). 

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

You can use this module by including it this way:

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "lb" {
  source  = "claranet/lb/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  allocate_public_ip = true
  enable_nat         = true
}
```

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_pool\_addresses | Map of IP Address Names and IP Addresses to be added to the default backend pool | `map(any)` | `{}` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add on all resources. | `map(string)` | `{}` | no |
| frontend\_subnet\_name | Name for the subnet where the load balancer frontend ip is deployed | `string` | n/a | yes |
| lb\_custom\_name | Name of the Load Balancer, generated if not set. | `string` | `""` | no |
| lb\_extra\_tags | Extra tags to add to the Load Balancer. | `map(string)` | `{}` | no |
| lb\_frontend\_ip\_configurations | `frontend_ip_configuration` blocks as documented here: https://www.terraform.io/docs/providers/azurerm/r/lb.html#frontend_ip_configuration | `map(any)` | `{}` | no |
| lb\_probes | `lb_probes` blocks as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe | `map(any)` | `{}` | no |
| lb\_rules | `lb_rules` blocks as documented here: https://www.terraform.io/docs/providers/azurerm/r/lb_rule | `map(any)` | `{}` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| region | Region where load balancer is deployed. | `string` | n/a | yes |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| sku\_name | The Name of the SKU used for this Load Balancer. Possible values are "Basic" and "Standard". | `string` | `"Standard"` | no |
| vnet\_name | Virtual network name | `string` | n/a | yes |
| vnet\_resource\_group\_name | Virtual Network Resource group name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backend\_address\_pool\_id | Id of the associated default backend address pool |
| backend\_address\_pool\_ip\_configurations | IP configurations of the associated default backend address pool |
| backend\_address\_pool\_load\_balancing\_rules | Load balancing rules of the associated default backend address pool |
| backend\_address\_pool\_name | Name of the associated default backend address pool |
| lb\_id | Id of the Load Balancer |
| lb\_name | Name of the Load Balancer |
| lb\_private\_ip\_address | Private IP address of the Load Balancer |
| lb\_private\_ip\_addresses | Private IP addresses of the Load Balancer |
| lb\_probe\_ids | Ids of the load balancer probe if any |
| lb\_rule\_id | Id of the load balancer rules if any |

## Related documentation

Terraform resource documentation: [terraform.io/docs/providers/azurerm/r/lb.html](https://www.terraform.io/docs/providers/azurerm/r/lb.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/load-balancer/](https://docs.microsoft.com/en-us/azure/load-balancer/)
