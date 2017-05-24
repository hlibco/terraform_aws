## Set Terraform version constraint
terraform {
  required_version = ">= 0.9.5"
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
 * DHCP
 ------------------------------------------------ */
module "dhcp" {
  source      = "./dhcp"
  name        = "${var.domain_name}"
  vpc_id      = "${module.vpc.id}"
  domain_name = "${var.domain_name}"
  servers     = "${coalesce(var.domain_name_servers, cidrhost(var.cidr, 2))}"
}

/**
 * DNS
 ------------------------------------------------ */
# module "dns" {
#   source = "./dns"
#   name   = "${var.domain_name}"
#   vpc_id = "${module.vpc.id}"
# }

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
 * IAM
 ------------------------------------------------ */
module "iam" {
  source          = "./iam"
  environment     = "${var.environment}"
  private_key     = "${file(var.iam_private_key)}"
  certificate_body = "${file(var.iam_certificate_body)}"
}

/**
 * ELB
 ------------------------------------------------ */
module "elb" {
  source            = "./elb"
  subnets           = ["${module.vpc.external_subnets}"]
  security_groups   = ["${module.security_groups.external_elb}"]
  ssl_certificate_id = "${module.iam.server_certificate}"
}

/**
 * EC2
 ------------------------------------------------ */
module "ec2" {
  source              = "./ec2"
  instance_type       = "${var.aws_instance_type}"
  image_id            = "${lookup(var.aws_amis, var.aws_region)}"
  iam_instance_profile = "${module.iam.instance_profile}"
  security_groups     = ["${module.security_groups.external_elb}", "${module.security_groups.external_ssh}"]
  capacity            = "${var.capacity}"
  volume_size         = 12
  availability_zones  = "${var.aws_availability_zones}"
  vpc_zone_identifier  = ["${module.vpc.external_subnets}"]
  key_name            = "${var.aws_key_name}"
  private_key         = "${file(var.aws_private_key)}"
  server_port         = 8080
  load_balancers      = ["${module.elb.external_elb}"]
}
