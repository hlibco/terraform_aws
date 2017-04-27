## Set Terraform version constraint
terraform {
  required_version = "> 0.8.0"
}

/**
 * VPC
 ------------------------------------------------ */
module "vpc" {
  source                = "./vpc"
  name                  = "${var.name}"
  cidr                  = "${var.cidr}"
  internal_subnets_cidr = "${var.internal_subnets_cidr}"
  external_subnets_cidr = "${var.external_subnets_cidr}"
  availability_zones    = "${var.aws_availability_zones}"
  environment           = "${var.environment}"
}

/**
 * SECURITY GROUPS
 ------------------------------------------------ */
module "security_groups" {
  source      = "./security_groups"
  name        = "${var.name}"
  vpc_id      = "${module.vpc.id}"
  cidr        = "${var.cidr}"
  key_name    = "${var.aws_key_name}"
  public_key  = "${var.aws_public_key}"
  environment = "${var.environment}"
}

/**
 * DNS
 ------------------------------------------------ */
module "dns" {
  source = "./dns"
  name   = "${var.domain_name}"
  vpc_id = "${module.vpc.id}"
}

/**
 * DHCP
 ------------------------------------------------ */
module "dhcp" {
  source      = "./dhcp"
  name        = "${module.dns.name}"
  vpc_id      = "${module.vpc.id}"
  domain_name = "${var.domain_name}"
  servers     = "${coalesce(var.domain_name_servers, cidrhost(var.cidr, 2))}"
}

# module "iam_role" {
#   source      = "./iam-role"
#   name        = "${var.name}"
#   environment = "${var.environment}"
# }

/**
 * DNS
 ------------------------------------------------ */
module "ec2" {
  source = "./ec2"
  # name   = "${var.domain_name}"
  instance_type      = "${var.aws_instance_type}"
  image_id           = "${lookup(var.aws_amis, var.aws_region)}"
  capacity           = "${var.capacity}"
  availability_zones = "${var.aws_availability_zones}"
  key_name           = "${var.aws_key_name}"
  private_key        = "${file(var.aws_private_key)}"
  server_port        = 8080
}
