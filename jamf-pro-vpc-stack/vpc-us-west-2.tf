variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR for the Public Subnet 1"
  default = "10.0.0.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR for the Private Subnet 1"
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for the Public Subnet 2"
  default = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for the Private Subnet 2"
  default = "10.0.3.0/24"
}

variable "availability_zone_1" {
  description = "Availability Zone 1"
  default = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Availability Zone 2"
  default = "us-east-1b"
}

variable "env_name" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

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
