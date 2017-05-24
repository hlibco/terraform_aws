variable "instance_type" {}
variable "image_id" {}
variable "vpc_zone_identifier" { type = "list" }
variable "security_groups" { type = "list" }
variable "iam_instance_profile" {}
variable "key_name" {}
variable "private_key" {}
variable "capacity" { type = "map" }
variable "availability_zones" { type = "list" }
variable "server_port" {}
variable "load_balancers" { type = "list" }
variable "volume_size" {}

/**
 * OUTPUT
 ------------------------------------------------ */
output "public_ip" {
  value = ["${aws_launch_configuration.worker.public_ip}"]
}

