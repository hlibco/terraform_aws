variable "instance_type" {}
variable "image_id" {}
variable "key_name" {}
variable "private_key" {}
variable "capacity" {
  type = "map"
}
variable "availability_zones" {
  type = "list"
}
variable "server_port" {}

# output "public_ip" {
#   value = "${aws_instance.worker.public_ip}"
# }
