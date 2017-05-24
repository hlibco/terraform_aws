resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = "${var.domain_name}"
  domain_name_servers = ["${split(",", var.domain_name_servers)}"]

  netbios_name_servers = ["${compact(var.netbios_name_servers)}"]
  netbios_node_type    = "${var.netbios_node_type}"
  ntp_servers          = ["${compact(var.ntp_servers)}"]

  tags {
    Name  = "${var.name}-dhcp"
    Group = "dhcp"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${var.vpc_id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}
