/**
 * VPC
 ------------------------------------------------ */
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.name}"
    Group       = "vpc"
    Environment = "${var.environment}"
  }
}

/**
 * Internet gateway
 ------------------------------------------------ */
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
  }
}

/**
 * Subnets
 ------------------------------------------------ */
 resource "aws_subnet" "external" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.external_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  count                   = "${length(var.external_subnets_cidr)}"
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = true

  tags {
    Name        = "${var.name}-${format("external-%03d", count.index+1)}"
    Group       = "subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "internal" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.internal_subnets_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.internal_subnets_cidr)}"

  tags {
    Name        = "${var.name}-${format("internal-%03d", count.index+1)}"
    Group       = "subnet"
    Environment = "${var.environment}"
  }
}

/**
 * Route tables
 ------------------------------------------------ */
resource "aws_route_table" "external" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.name}-external-001"
    Group       = "route_table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "internal" {
  count  = "${length(var.internal_subnets_cidr)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.name}-${format("internal-%03d", count.index+1)}"
    Group       = "route_table"
    Environment = "${var.environment}"
  }
}

/**
 * Route associations
 ------------------------------------------------ */
resource "aws_route_table_association" "external" {
  count          = "${length(var.external_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.external.*.id, count.index)}"
  route_table_id = "${aws_route_table.external.id}"
}

resource "aws_route_table_association" "internal" {
  count          = "${length(var.internal_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.internal.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.internal.*.id, count.index)}"
}

/**
 * Route
 ------------------------------------------------ */
resource "aws_route" "external" {
  route_table_id         = "${aws_route_table.external.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
