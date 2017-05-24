variable "name" {
  description = "The domain name to setup DHCP for"
}

variable "vpc_id" {
  description = "The ID of the VPC to setup DHCP for"
}

variable "domain_name" {
  description = "The internal DNS name to use with services"
}

variable "domain_name_servers" {
  description = "A comma separated list of the IP addresses of internal DHCP servers"
}

variable "ntp_servers" { type = "list" }
variable "netbios_node_type" {}
variable "netbios_name_servers" { type = "list" }
