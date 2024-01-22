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

resource "vcd_nsxt_network_dhcp" "pool" {
  count               = var.dhcp_pool == null ? 0 : 1
  org                 = var.vdc_org_name
  org_network_id      = vcd_network_routed_v2.network_routed_v2.id
  mode                = var.dhcp_pool.dhcp_mode
  listener_ip_address = var.dhcp_pool.dhcp_mode == "NETWORK" ? var.dhcp_pool.listener_ip_address : null
  lease_time          = var.dhcp_pool.lease_time
  dns_servers         = var.dhcp_pool.dhcp_mode == "RELAY" ? null : var.dhcp_pool.dns_servers

  dynamic "pool" {
    for_each = var.dhcp_pool.dhcp_mode == "RELAY" ? [] : var.dhcp_pool.pool_ranges
    content {
      start_address = pool.value.start_address
      end_address   = pool.value.end_address
    }
  }
}
