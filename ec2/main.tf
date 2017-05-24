/**
 * Launch Configuration
 ------------------------------------------------ */
resource "aws_launch_configuration" "worker" {
  name            = "worker"
  image_id        = "${var.image_id}"
  instance_type   = "${var.instance_type}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  key_name        = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups     = ["${var.security_groups}"]
  iam_instance_profile = "${var.iam_instance_profile}"

  # user_data         = "${template_file.heavy_user_data.rendered}"
  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "Hello, World" > index.html
  #             nohup busybox httpd -f -p "${var.server_port}" &
  #             EOF

  # Storage
  ebs_block_device {
    device_name           = "/dev/xvdf"
    volume_size           = "${var.volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user" # ec2-user / ubuntu
  #   agent       = true
  #   timeout     = "2m"
  #   private_key = "${var.private_key}"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get -y update"
  #   ]
  # }

  lifecycle {
    create_before_destroy = true
  }
}

/**
 * Placement Group
 ------------------------------------------------ */
resource "aws_placement_group" "worker" {
  name     = "workers"
  strategy = "cluster"
}

/**
 * Autoscaling Group
 ------------------------------------------------ */
resource "aws_autoscaling_group" "worker" {
  //We want this to explicitly depend on the launch config above
  depends_on                = ["aws_launch_configuration.worker"]
  name                      = "workers"

  launch_configuration       = "${aws_launch_configuration.worker.name}"
  availability_zones        = ["${var.availability_zones}"]
  vpc_zone_identifier        = ["${var.vpc_zone_identifier}"]

  max_size                  = "${var.capacity["max"] }"
  min_size                  = "${var.capacity["min"] }"
  desired_capacity          = "${var.capacity["desired"] }"
  wait_for_capacity_timeout = "0m" # 0 disables wait for ASG capacity
  health_check_grace_period = 300
  default_cooldown          = 300
  health_check_type         = "EC2"
  force_delete              = true
  min_elb_capacity          = 0 # 0 skips waiting for instances attached to the load balancer
  load_balancers            = ["${var.load_balancers}"]

  # It does not work with instance type t2.micro
  # placement_group           = "${aws_placement_group.default.id}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "worker-${format("%03d", count.index+1)}"
    propagate_at_launch = "true"
  }
}

/**
 * Dependencies
 ------------------------------------------------ */
resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_autoscaling_group.worker",
    "aws_launch_configuration.worker",
  ]
}
