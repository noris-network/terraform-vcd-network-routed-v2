# terraform-vcd-network-routed-v2

Terraform module which manages NSX-T/V backed routed VDC network ressources on VMWare Cloud Director.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_vcd"></a> [vcd](#requirement\_vcd) | >= 3.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vcd"></a> [vcd](#provider\_vcd) | 3.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vcd_network_routed_v2.network_routed_v2](https://registry.terraform.io/providers/vmware/vcd/latest/docs/resources/network_routed_v2) | resource |
| [vcd_nsxt_network_dhcp.pool](https://registry.terraform.io/providers/vmware/vcd/latest/docs/resources/nsxt_network_dhcp) | resource |
| [vcd_nsxt_edgegateway.nsxt_edgegateway](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/nsxt_edgegateway) | data source |
| [vcd_vdc_group.vdc_group](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/vdc_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway"></a> [gateway](#input\_gateway) | The IP-address of the gateway in this network. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the network. | `string` | n/a | yes |
| <a name="input_prefix_length"></a> [prefix\_length](#input\_prefix\_length) | The prefix length for the new network. | `number` | n/a | yes |
| <a name="input_vdc_edgegateway_name"></a> [vdc\_edgegateway\_name](#input\_vdc\_edgegateway\_name) | The name for the Edge Gateway this network connects to. | `string` | n/a | yes |
| <a name="input_vdc_group_name"></a> [vdc\_group\_name](#input\_vdc\_group\_name) | The name of the VDC group. | `string` | n/a | yes |
| <a name="input_vdc_org_name"></a> [vdc\_org\_name](#input\_vdc\_org\_name) | The name of the organization to use. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | An optional description of the network. | `string` | `null` | no |
| <a name="input_dhcp_pool"></a> [dhcp\_pool](#input\_dhcp\_pool) | IP ranges to configure DHCP for. | <pre>object({<br>    listener_ip_address = optional(string)<br>    pool_ranges         = optional(list(map(string)), [{start_address = "192.168.1.150", end_address = "192.168.1.199"}])<br>    dns_servers         = optional(list(string))<br>    dhcp_mode           = optional(string, "EDGE")<br>    lease_time          = optional(number, 4294967295)<br>  })</pre> | `null` | no |
| <a name="input_dns1"></a> [dns1](#input\_dns1) | First DNS server to use. | `string` | `null` | no |
| <a name="input_dns2"></a> [dns2](#input\_dns2) | Second DNS server to use. | `string` | `null` | no |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | A FQDN for the virtual machines on this network. | `string` | `null` | no |
| <a name="input_dual_stack_enabled"></a> [dual\_stack\_enabled](#input\_dual\_stack\_enabled) | Enables Dual-Stack mode so that one can configure one IPv4 and one IPv6 networks. Note In such case IPv4 addresses must be used in gateway, prefix\_length and static\_ip\_pool while IPv6 addresses in secondary\_gateway, secondary\_prefix\_length and secondary\_static\_ip\_pool fields. | `bool` | `false` | no |
| <a name="input_interface_type"></a> [interface\_type](#input\_interface\_type) | An interface for the network. One of internal, subinterface, distributed (requires the edge gateway to support distributed networks). NSX-T supports only internal. | `string` | `"internal"` | no |
| <a name="input_metadata_entry"></a> [metadata\_entry](#input\_metadata\_entry) | A set of metadata entries to assign. | `list(map(string))` | `[]` | no |
| <a name="input_secondary_gateway"></a> [secondary\_gateway](#input\_secondary\_gateway) | IPv6 gateway when Dual-Stack mode is enabled. | `string` | `null` | no |
| <a name="input_secondary_prefix_length"></a> [secondary\_prefix\_length](#input\_secondary\_prefix\_length) | IPv6 prefix length when Dual-Stack mode is enabled. | `number` | `null` | no |
| <a name="input_secondary_static_ip_pool"></a> [secondary\_static\_ip\_pool](#input\_secondary\_static\_ip\_pool) | One or more IPv6 static pools when Dual-Stack mode is enabled. | `list(map(string))` | `[]` | no |
| <a name="input_static_ip_pool"></a> [static\_ip\_pool](#input\_static\_ip\_pool) | Static IP-pools create for this network. | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of this network. |
| <a name="output_name"></a> [name](#output\_name) | The Name of this network. |
<!-- END_TF_DOCS -->

## Examples

```
module "org_network" {
  source               = "git::https://github.com/noris-network/terraform-vcd-network-routed-v2?ref=1.1.0"
  name                 = "myNet"
  vdc_org_name         = "myORG"
  vdc_edgegateway_name = "T1-myORG"
  vdc_group_name       = "myDCGroup"
  prefix_length        = 24
  gateway              = "192.168.0.1"
  static_ip_pool       = [
    {
      start_address = "192.168.0.100"
      end_address   = "192.168.0.149"
    }
  ]
  dhcp_pool =  {
    pool_ranges = [
      {
        start_address = "192.168.0.150"
        end_address   = "192.168.0.199"
      }
    ]
    listener_ip_address = "192.168.0.1"
    dns_servers = ["8.8.8.8", "8.8.8.8"]
    dhcp_mode   = "EDGE"
    lease_time  = 86400
  }
}
```

## Changelog

  * `v1.1.0`  - Add posibility to add DHCP scopes to Org Network
  * `v1.0.0`  - Initial release
  