variable "vdc_org_name" {
  description = "The name of the organization to use."
  type        = string
}

variable "name" {
  description = "Name for the network."
  type        = string
}

variable "description" {
  description = "An optional description of the network."
  type        = string
  default     = null
}

variable "interface_type" {
  description = "An interface for the network. One of internal, subinterface, distributed (requires the edge gateway to support distributed networks). NSX-T supports only internal."
  type        = string
  default     = "internal"
}

variable "vdc_group_name" {
  description = "The name of the VDC group."
  type        = string
}

variable "vdc_edgegateway_name" {
  description = "The name for the Edge Gateway this network connects to."
  type        = string
}

variable "gateway" {
  description = "The IP-address of the gateway in this network."
  type        = string
}

variable "prefix_length" {
  description = "The prefix length for the new network."
  type        = number
}

variable "dns1" {
  description = "First DNS server to use."
  type        = string
  default     = null
}

variable "dns2" {
  description = "Second DNS server to use."
  type        = string
  default     = null
}

variable "dns_suffix" {
  description = "A FQDN for the virtual machines on this network."
  type        = string
  default     = null
}

variable "static_ip_pool" {
  description = "Static IP-pools create for this network."
  type        = list(map(string))
  default     = []
}

variable "metadata_entry" {
  description = "A set of metadata entries to assign."
  type        = list(map(string))
  default     = []
}

variable "dual_stack_enabled" {
  description = "Enables Dual-Stack mode so that one can configure one IPv4 and one IPv6 networks. Note In such case IPv4 addresses must be used in gateway, prefix_length and static_ip_pool while IPv6 addresses in secondary_gateway, secondary_prefix_length and secondary_static_ip_pool fields."
  type        = bool
  default     = false
}

variable "secondary_gateway" {
  description = "IPv6 gateway when Dual-Stack mode is enabled."
  type        = string
  default     = null
}

variable "secondary_prefix_length" {
  description = "IPv6 prefix length when Dual-Stack mode is enabled."
  type        = number
  default     = null
}

variable "secondary_static_ip_pool" {
  description = "One or more IPv6 static pools when Dual-Stack mode is enabled."
  type        = list(map(string))
  default     = []
}

variable "dhcp_pool" {
  description = "IP ranges to configure DHCP for."
  type = object({
    listener_ip_address = optional(string)
    pool_ranges         = optional(list(map(string)), [{ start_address = "192.168.0.150", end_address = "192.168.0.199" }])
    dns_servers         = optional(list(string))
    dhcp_mode           = optional(string, "EDGE")
    lease_time          = optional(number, 4294967295)
  })
  default = null
}
