data "vcd_vdc_group" "vdc_group" {
  name = var.vdc_group_name
}

data "vcd_nsxt_edgegateway" "nsxt_edgegateway" {
  org      = var.vdc_org_name
  owner_id = data.vcd_vdc_group.vdc_group.id
  name     = var.vdc_edgegateway_name
}

resource "vcd_network_routed_v2" "network_routed_v2" {
  org                     = var.vdc_org_name
  name                    = var.name
  edge_gateway_id         = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  description             = var.description
  dns1                    = var.dns1
  dns2                    = var.dns2
  dns_suffix              = var.dns_suffix
  gateway                 = var.gateway
  prefix_length           = var.prefix_length
  interface_type          = var.interface_type
  dual_stack_enabled      = var.dual_stack_enabled
  secondary_gateway       = var.secondary_gateway
  secondary_prefix_length = var.secondary_prefix_length

  dynamic "static_ip_pool" {
    for_each = length(var.static_ip_pool) > 0 ? var.static_ip_pool : []
    content {
      start_address = static_ip_pool.value.start_address
      end_address   = static_ip_pool.value.end_address
    }
  }

  dynamic "secondary_static_ip_pool" {
    for_each = length(var.secondary_static_ip_pool) > 0 ? var.secondary_static_ip_pool : []
    content {
      start_address = secondary_static_ip_pool.value.start_address
      end_address   = secondary_static_ip_pool.value.end_address
    }
  }

  dynamic "metadata_entry" {
    for_each = length(var.metadata_entry) > 0 ? var.metadata_entry : []
    content {
      key         = metadata_entry.value.key
      value       = metadata_entry.value.value
      type        = metadata_entry.value.type
      user_access = metadata_entry.value.user_access
      is_system   = metadata_entry.value.is_system
    }
  }
}
