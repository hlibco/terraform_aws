variable "name" {
  description = "Name tag, e.g stack"
  default     = "terraform"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "external_subnets_cidr" {
  description = "List of external subnets"
  type        = "list"
}

variable "internal_subnets_cidr" {
  description = "List of internal subnets"
  type        = "list"
}

variable "environment" {
  description = "Environment tag, e.g production"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = "list"
}

/**
 * OUTPUT
 ------------------------------------------------ */
// The VPC ID
output "id" {
  value = "${aws_vpc.main.id}"
}

// A comma-separated list of subnet IDs.
output "external_subnets" {
  value = ["${aws_subnet.external.*.id}"]
}

// A list of subnet IDs.
output "internal_subnets" {
  value = ["${aws_subnet.internal.*.id}"]
}

// The default VPC security group ID.
output "security_group" {
  value = "${aws_vpc.main.default_security_group_id}"
}

// The list of availability zones of the VPC.
output "availability_zones" {
  value = ["${aws_subnet.external.*.availability_zone}"]
}

// The external route table ID.
output "external_rtb_id" {
  value = "${aws_route_table.external.id}"
}

// The internal route table ID.
output "internal_rtb_id" {
  value = "${join(",", aws_route_table.internal.*.id)}"
}
