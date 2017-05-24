variable "environment" {}
variable "private_key" {
  description = "Local path to the server private key",
}
variable "certificate_body" {
  description = "Local path to the server .crt file",
}

/**
 * OUTPUT
 ------------------------------------------------ */
output "instance_profile" {
  value = "${aws_iam_instance_profile}"
}
output "server_certificate" {
  value = "${aws_iam_server_certificate.www.arn}"
}
