provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.profile}"

  # Note: Do not set the path to the credentials file, in order to use the default AWS credentials.
  # https://github.com/hashicorp/terraform/issues/5610
  # shared_credentials_file = "${var.shared_credentials_file}"
}
