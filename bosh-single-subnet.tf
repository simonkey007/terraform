variable "access_key" {}

variable "secret_key" {}

variable "region" {}

variable "key_name" {
  default = "bosh"
}
variable "public_key" {}

variable "env_name" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "${var.env_name}"
  }
}
