resource "aws_elb" "external" {
  name                        = "heavy"
  subnets                     = ["${var.subnets}"]
  security_groups             = ["${var.security_groups}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id  = "${var.ssl_certificate_id}"
    # ssl_certificate_id  = "${terraform_remote_state.shared.output.iam_server_certificate_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 7
    timeout             = 5
    target              = "HTTP:80/"
  }

  lifecycle {
    create_before_destroy = true
  }
}
