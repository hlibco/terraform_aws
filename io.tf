variable "name" {
  description = "The name of your stack, e.g. \"segment\""
  default     = "playground"
}

variable "environment" {
  description = "The name of your environment, e.g. \"production-west\""
  default     = "development"
}

/**
 * DNS
 ------------------------------------------------ */
variable "domain_name" {
  description = "The internal DNS name to use with services"
  default     = "playground.local"
}

variable "domain_name_servers" {
  description = "The internal DNS servers, defaults to the internal route53 server of the VPC"
  default     = ""
}

/**
 * Credentials
 ------------------------------------------------ */
variable "aws_key_name" {
  description = "Desired name of AWS key pair",
  default     = "terraform"
}

variable "aws_public_key" {
  description = "Local path to the AWS public key .pub",
  default     = "~/.aws/terraform.pub"
}

variable "aws_private_key" {
  description = "Local path to the AWS private key",
  default     = "~/.aws/terraform"
}

# https://www.terraform.io/docs/providers/aws/index.html
# Shared Credentials file
variable "shared_credentials_file" {
  description = "Local path to the AWS credentials (access_key and secret_key)",
  default     = "~/.aws/config"
}
variable "profile" {
  description = "Profile used in the aws credentials file",
  default     = "terraform"
}

/**
 * Region / Availability Zones / Instance Type
 ------------------------------------------------ */
variable "aws_region" {
  description = "AWS region to launch EC2 servers for the VPC"
  default     = "us-west-1"
}

variable "aws_availability_zones" {
  description = "A comma-separated list of availability zones. Defaults to all AZ of the region, if set to something other than the defaults, both internal_subnets and external_subnets have to be defined as well"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "aws_instance_type" {
  description = "AWS instance type",
  default     = "t2.micro"
}

variable "aws_amis" {
  default = {
    us-west-1 = "ami-f1810f86" # Ubuntu 14.04 LTS
  }
}

/**
 * Auto scaling
 ------------------------------------------------ */
variable "capacity" {
  default = {
    min     = 1
    max     = 1
    desired = 1
  }
}


/**
 * VPC
 ------------------------------------------------ */
variable "cidr" {
  description = "CIDR for the whole VPC"
  default      = "10.0.0.0/16"
}

variable "internal_subnets_cidr" {
  description = "CIDR for the Private Subnet. Must be set if the cidr variable is defined, needs to have as many elements as there are availability zones."
  default     = ["10.1.0.0/19" ,"10.1.64.0/19", "10.1.128.0/19"]
}

variable "external_subnets_cidr" {
  description = "CIDR for the Public Subnet. Must be set if the cidr variable is defined, needs to have as many elements as there are availability zones."
  default     = ["10.1.32.0/20", "10.1.96.0/20", "10.1.160.0/20"]
}


/**
 * OUTPUT
 ------------------------------------------------ */
// The name of the stack, e.g "playground".
output "name" {
  value = "${var.name}"
}

// The environment of the stack, e.g "production".
output "environment" {
  value = "${var.environment}"
}

# // The region in which the infra lives.
# output "region" {
#   value = "${var.region}"
# }

# // Security group for internal ELBs.
# output "internal_elb" {
#   value = "${module.security_groups.internal_elb}"
# }

# // Security group for external ELBs.
# output "external_elb" {
#   value = "${module.security_groups.external_elb}"
# }

# // Comma separated list of internal subnet IDs.
# output "internal_subnets" {
#   value = "${module.vpc.internal_subnets}"
# }

# // Comma separated list of external subnet IDs.
# output "external_subnets" {
#   value = "${module.vpc.external_subnets}"
# }

# // ECS Service IAM role.
# output "iam_role" {
#   value = "${module.iam_role.arn}"
# }

# // Default ECS role ID. Useful if you want to add a new policy to that role.
# output "iam_role_default_ecs_role_id" {
#   value = "${module.iam_role.default_ecs_role_id}"
# }

# // The internal domain name, e.g "stack.local".
# output "domain_name" {
#   value = "${module.dns.name}"
# }

# // The default ECS cluster name.
# output "cluster" {
#   value = "${module.ecs_cluster.name}"
# }

# // The VPC availability zones.
# output "availability_zones" {
#   value = "${module.vpc.availability_zones}"
# }

// The VPC security group ID.
output "vpc_security_group" {
  value = "${module.vpc.security_group}"
}

# // The VPC ID.
# output "vpc_id" {
#   value = "${module.vpc.id}"
# }

# // Comma separated list of internal route table IDs.
# output "internal_route_tables" {
#   value = "${module.vpc.internal_rtb_id}"
# }

# // The external route table ID.
# output "external_route_tables" {
#   value = "${module.vpc.external_rtb_id}"
# }
