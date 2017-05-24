variable "subnets" { type = "list" }
variable "security_groups" { type = "list" }
variable "ssl_certificate_id" {}

/**
 * OUTPUT
 ------------------------------------------------ */
output "external_elb" {
  value = "${aws_elb.external.name}"
}

