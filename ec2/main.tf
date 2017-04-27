/**
 * Launch Configuration
 ------------------------------------------------ */
resource "aws_launch_configuration" "worker" {
  # iam_instance_profile = "${ var.instance-profile-name }"
  image_id        = "${var.image_id}"
  instance_type   = "${var.instance_type}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  #
  key_name        = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  # subnet_id              = "${module.vpc.external_subnets}"
  # vpc_security_group_ids = ["${module.security_groups.external_elb}", "${module.security_groups.external_ssh}"]

  # security_groups = [
  #   "${aws_security_group.external_elb.id}",
  #   "${aws_security_group.external_ssh.id}"
  # ]

  # user_data = "${ data.template_file.cloud-config.rendered }"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  # Storage
  ebs_block_device {
    device_name = "/dev/xvdf"
    # volume_size = "${ var.volume_size["ebs"] }"
    volume_type = "gp2"
  }

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    type    = "ssh"
    user    = "ubuntu" # ec2-user
    agent   = true
    timeout = "2m"
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  launch_configuration       = "${aws_launch_configuration.worker.name}"
  availability_zones        = ["${var.availability_zones}"]
  name                      = "worker-${format("%03d", count.index+1)}"
  max_size                  = "${var.capacity["max"] }"
  min_size                  = "${var.capacity["min"] }"
  desired_capacity          = "${var.capacity["desired"] }"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  # load_balancers          = ["${aws_elb.web_lb.name}"]
  # vpc_zone_identifier      = [ "${ split(",", var.external_subnets_cidr) }" ]


  # tags {
  #   Name  = "worker-${format("%03d", count.index+1)}"
  #   Group = "workers"
  # }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "aws_autoscaling_group.worker",
    "aws_launch_configuration.worker",
  ]
}
