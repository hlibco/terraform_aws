/**
 * The dns module creates a local route53 zone that serves
 * as a service discovery utility.
 */

resource "aws_route53_zone" "main" {
  name    = "${var.name}"
  vpc_id  = "${var.vpc_id}"
  comment = "Managed by Terraform"
}

resource "aws_route53_record" "api-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "api.${var.name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]
}
