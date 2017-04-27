/**
 * Creates basic security groups to be used by instances and ELBs.
 */



/**
 * Key pair
 ------------------------------------------------ */
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key)}"

  lifecycle {
    create_before_destroy = true
  }
}

/**
 * ELB Internal and External
 ------------------------------------------------ */
resource "aws_security_group" "internal_elb" {
  name        = "${format("%s-%s-internal-elb", var.name, var.environment)}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows internal ELB traffic"

  # HTTP access from vpc
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  # Outbound vpc access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal elb", var.name)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "external_elb" {
  name        = "${format("%s-%s-external-elb", var.name, var.environment)}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows external ELB traffic"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s external elb", var.name)}"
    Environment = "${var.environment}"
  }
}

/**
 * SSH Internal and External
 ------------------------------------------------ */
resource "aws_security_group" "internal_ssh" {
  name        = "${format("%s-%s-internal-ssh", var.name, var.environment)}"
  description = "Allows ssh from bastion"
  vpc_id      = "${var.vpc_id}"

  # SSH access from vpc
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.external_ssh.id}"]
  }

  # Outbound vpc access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s internal ssh", var.name)}"
    Environment = "${var.environment}"
  }
}


resource "aws_security_group" "external_ssh" {
  name        = "${format("%s-%s-external-ssh", var.name, var.environment)}"
  description = "Allows ssh from the world"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s external ssh", var.name)}"
    Environment = "${var.environment}"
  }
}
