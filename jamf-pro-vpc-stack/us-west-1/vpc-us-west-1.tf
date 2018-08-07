variable "env_name" {}

variable "vpc_cidr" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "availability_zone_1" {
  type    = "string"
  default = "us-west-1a"
}
variable "availability_zone_2" {
  type    = "string"
  default = "us-west-1c"
}
variable "public_subnet_1_cidr" {
  type    = "string"
  default = "10.0.0.0/24"
}
variable "private_subnet_1_cidr" {
  type    = "string"
  default = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  type    = "string"
  default = "10.0.2.0/24"
}
variable "private_subnet_2_cidr" {
  type    = "string"
  default = "10.0.3.0/24"
}

provider "aws" {}

resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.env_name} VPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "${var.env_name} IG"
    Network = "Public"
  }
}

resource "aws_subnet" "public_1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_1_cidr}"
    availability_zone = "${var.availability_zone_1}"

    tags {
        Name = "${var.env_name} Public Subnet 1"
        Network = "Public"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_2_cidr}"
    availability_zone = "${var.availability_zone_2}"

    tags {
        Name = "${var.env_name} Public Subnet 2"
        Network = "Public"
    }
}

resource "aws_subnet" "private_1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_1_cidr}"
    availability_zone = "${var.availability_zone_1}"

    tags {
        Name = "${var.env_name} Private Subnet 1"
        Network = "Private"
    }
}

resource "aws_subnet" "private_2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_2_cidr}"
    availability_zone = "${var.availability_zone_2}"

    tags {
        Name = "${var.env_name} Private Subnet 2"
        Network = "Private"
    }
}

resource "aws_eip" "nat_1" {
    vpc = true
}

resource "aws_eip" "nat_2" {
    vpc = true
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = "${aws_eip.nat_1.id}"
  subnet_id     = "${aws_subnet.public_1.id}"

  tags {
    Name = "${var.env_name} NAT GW 1"
    Network = "Public"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = "${aws_eip.nat_2.id}"
  subnet_id     = "${aws_subnet.public_2.id}"

  tags {
    Name = "${var.env_name} NAT GW 2"
    Network = "Public"
  }
}

resource "aws_route_table" "public_1" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "${var.env_name} RT public 1"
  }
}

resource "aws_route_table" "public_2" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "${var.env_name} RT public 2"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.public_1.id}"
}

resource "aws_route_table_association" "public_2" {
  subnet_id = "${aws_subnet.public_2.id}"
  route_table_id = "${aws_route_table.public_2.id}"
}

resource "aws_route_table" "private_1" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_1.id}"
  }

  tags {
    Name = "${var.env_name} RT Private 1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_2.id}"
  }

  tags {
    Name = "${var.env_name} RT Private 2"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.private_1.id}"
}

resource "aws_route_table_association" "private_2" {
  subnet_id = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.private_2.id}"
}

resource "aws_security_group" "elb_sg" {
  vpc_id = "${aws_vpc.default.id}"
  name = "elb-sg-${var.env_name}"
  description = "Allow access to ELB on port 80"

  ingress {
    from_port = 0
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env_name} ELB SG"
  }
}
