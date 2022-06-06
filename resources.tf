module "edge_services" {
  for_each                         = toset(local.resource_locations)
  source                           = "github.com/wesley-trust/tfmodule-compute?ref=v1-compute"
  service_environment              = terraform.workspace
  service_deployment               = var.service_deployment
  service_name                     = var.service_name
  service_location                 = each.value
  resource_name                    = local.resource_name
  resource_instance_count          = local.resource_instance_count
  resource_instance_size           = local.resource_instance_size
  resource_vm_sku                  = var.resource_vm_sku
  resource_network_interface_count = var.resource_network_interface_count
  resource_address_space           = lookup(var.resource_address_space, each.value, null)
  resource_dns_servers             = lookup(var.resource_dns_servers, each.value, null)
  resource_network_role            = var.resource_network_role
  operating_system_platform        = var.operating_system_platform
}

module "edge_services_network_peering" {
  for_each                   = toset(local.resource_locations)
  source                     = "github.com/wesley-trust/tfmodule-network_peering?ref=v1-network_peering"
  service_environment        = terraform.workspace
  resource_network_peer      = module.edge_services[each.value].network_name
  resource_group_peer        = module.edge_services[each.value].resource_group_name
  resource_network_peer_role = var.resource_network_peer_role
}

module "edge_services_bcdr" {
  for_each                         = toset(local.resource_bcdr_locations)
  source                           = "github.com/wesley-trust/tfmodule-compute?ref=v1-compute"
  service_environment              = terraform.workspace
  service_deployment               = var.service_deployment
  service_name                     = var.service_name
  service_location                 = each.value
  resource_name                    = local.resource_name
  resource_instance_count          = local.resource_bcdr_instance_count
  resource_instance_size           = local.resource_bcdr_instance_size
  resource_vm_sku                  = var.resource_vm_sku
  resource_network_interface_count = var.resource_network_interface_count
  resource_address_space           = lookup(var.resource_address_space, each.value, null)
  resource_dns_servers             = lookup(var.resource_dns_servers, each.value, null)
  resource_network_role            = var.resource_network_role
  operating_system_platform        = var.operating_system_platform
}

module "edge_services_network_peering_bcdr" {
  for_each                   = toset(local.resource_bcdr_locations)
  source                     = "github.com/wesley-trust/tfmodule-network_peering?ref=v1-network_peering"
  service_environment        = terraform.workspace
  resource_network_peer      = module.edge_services_bcdr[each.value].network_name
  resource_group_peer        = module.edge_services_bcdr[each.value].resource_group_name
  resource_network_peer_role = var.resource_network_peer_role
}
