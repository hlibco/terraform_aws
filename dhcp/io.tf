variable "name" {
  description = "The domain name to setup DHCP for"
}

variable "vpc_id" {
  description = "The ID of the VPC to setup DHCP for"
}

variable "domain_name" {
  description = "The internal DNS name to use with services"
}

variable "servers" {
  description = "A comma separated list of the IP addresses of internal DHCP servers"
}
