variable "env_name" {}
variable "key" {}

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

#####################################
# 888     888 8888888b.   .d8888b.  #
# 888     888 888   Y88b d88P  Y88b #
# 888     888 888    888 888    888 #
# Y88b   d88P 888   d88P 888        #
#  Y88b d88P  8888888P"  888        #
#   Y88o88P   888        888    888 #
#    Y888P    888        Y88b  d88P #
#     Y8P     888         "Y8888P"  #
#####################################


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

####################################################################################
#  .d8888b.   888     888 888888b.   888b    888 8888888888 88888888888  .d8888b.  #
# d88P  Y88b  888     888 888  "88b  8888b   888 888            888     d88P  Y88b #
# Y88b.       888     888 888  .88P  88888b  888 888            888     Y88b.      #
#  "Y888b.    888     888 8888888K.  888Y88b 888 8888888        888      "Y888b.   #
#     "Y88b.  888     888 888  "Y88b 888 Y88b888 888            888         "Y88b. #
#       "888  888     888 888    888 888  Y88888 888            888           "888 #
#  Y88b  d88P Y88b. .d88P 888   d88P 888   Y8888 888            888     Y88b  d88P #
#  "Y8888P"    "Y88888P"  8888888P"  888    Y888 8888888888     888      "Y8888P"  #
####################################################################################

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

############################################
# 8888888888 8888888 8888888b.   .d8888b.  #
# 888          888   888   Y88b d88P  Y88b #
# 888          888   888    888 Y88b.      #
# 8888888      888   888   d88P  "Y888b.   #
# 888          888   8888888P"      "Y88b. #
# 888          888   888              "888 #
# 888          888   888        Y88b  d88P #
# 8888888888 8888888 888         "Y8888P"  #
############################################

resource "aws_eip" "nat_1" {
    vpc = true
}

resource "aws_eip" "nat_2" {
    vpc = true
}

###################################################
# 888b    888        d8888 88888888888  .d8888b.  #
# 8888b   888       d88888     888     d88P  Y88b #
# 88888b  888      d88P888     888     Y88b.      #
# 888Y88b 888     d88P 888     888      "Y888b.   #
# 888 Y88b888    d88P  888     888         "Y88b. #
# 888  Y88888   d88P   888     888           "888 #
# 888   Y8888  d8888888888     888     Y88b  d88P #
# 888    Y888 d88P     888     888      "Y8888P"  #
###################################################

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

########################################################################
# 8888888b.   .d88888b.  888     888 88888888888 8888888888  .d8888b.  #
# 888   Y88b d88P" "Y88b 888     888     888     888        d88P  Y88b #
# 888    888 888     888 888     888     888     888        Y88b.      #
# 888   d88P 888     888 888     888     888     8888888     "Y888b.   #
# 8888888P"  888     888 888     888     888     888            "Y88b. #
# 888 T88b   888     888 888     888     888     888              "888 #
# 888  T88b  Y88b. .d88P Y88b. .d88P     888     888        Y88b  d88P #
# 888   T88b  "Y88888P"   "Y88888P"      888     8888888888  "Y8888P"  #
########################################################################

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

###################################################################################################################################################################
#  .d8888b.  8888888888  .d8888b.  888     888 8888888b.  8888888 88888888888 Y88b   d88P      .d8888b.  8888888b.   .d88888b.  888     888 8888888b.   .d8888b.  #
# d88P  Y88b 888        d88P  Y88b 888     888 888   Y88b   888       888      Y88b d88P      d88P  Y88b 888   Y88b d88P" "Y88b 888     888 888   Y88b d88P  Y88b #
# Y88b.      888        888    888 888     888 888    888   888       888       Y88o88P       888    888 888    888 888     888 888     888 888    888 Y88b.      #
#  "Y888b.   8888888    888        888     888 888   d88P   888       888        Y888P        888        888   d88P 888     888 888     888 888   d88P  "Y888b.   #
#     "Y88b. 888        888        888     888 8888888P"    888       888         888         888  88888 8888888P"  888     888 888     888 8888888P"      "Y88b. #
#       "888 888        888    888 888     888 888 T88b     888       888         888         888    888 888 T88b   888     888 888     888 888              "888 #
# Y88b  d88P 888        Y88b  d88P Y88b. .d88P 888  T88b    888       888         888         Y88b  d88P 888  T88b  Y88b. .d88P Y88b. .d88P 888        Y88b  d88P #
#  "Y8888P"  8888888888  "Y8888P"   "Y88888P"  888   T88b 8888888     888         888          "Y8888P88 888   T88b  "Y88888P"   "Y88888P"  888         "Y8888P"  #
###################################################################################################################################################################

resource "aws_security_group" "alb_sg" {
  vpc_id = "${aws_vpc.default.id}"
  name = "alb-sg-${var.env_name}"
  description = "Allow access to ALB on port 80"

  ingress {
    from_port = 80
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
    Name = "${var.env_name} ALB SG"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = "${aws_vpc.default.id}"
  name = "ec2-sg-${var.env_name}"
  description = "Allow access to EC2 on port 80"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ "${aws_security_group.alb_sg.id}" ]
  }

  ingress {
    from_port = 22
    to_port = 22
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
    Name = "${var.env_name} EC2 SG"
  }
}

####################################
# 8888888888  .d8888b.   .d8888b.  #
# 888        d88P  Y88b d88P  Y88b #
# 888        888    888        888 #
# 8888888    888             .d88P #
# 888        888         .od888P"  #
# 888        888    888 d88P"      #
# 888        Y88b  d88P 888"       #
# 8888888888  "Y8888P"  888888888  #
####################################

resource "aws_key_pair" "test" {
  key_name   = "test-key"
  public_key = "${var.key}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web1" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ec2_sg.id}" ]
  key_name = "test-key"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.public_1.id}"

  tags {
    Name = "web1-${var.env_name}"
  }
}

resource "aws_instance" "web2" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ec2_sg.id}" ]
  key_name = "test-key"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.public_2.id}"

  tags {
    Name = "web2-${var.env_name}"
  }
}

module "ansible_provisioner1" {
  source    = "github.com/cloudposse/tf_ansible"

  arguments = ["--user=ubuntu"]
  envs      = ["host=${aws_instance.web1.public_ip}"]
  playbook  = "../terraform-git/playbooks/playbook.yml"
  dry_run   = false

}

module "ansible_provisioner2" {
  source    = "github.com/cloudposse/tf_ansible"

  arguments = ["--user=ubuntu"]
  envs      = ["host=${aws_instance.web2.public_ip}"]
  playbook  = "../terraform-git/playbooks/playbook.yml"
  dry_run   = false

}

#######################
# 888      888888b.   #
# 888      888  "88b  #
# 888      888  .88P  #
# 888      8888888K.  #
# 888      888  "Y88b #
# 888      888    888 #
# 888      888   d88P #
# 88888888 8888888P"  #
#######################

resource "aws_lb" "test" {
  name               = "alb-${var.env_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = ["${aws_subnet.public_1.id}","${aws_subnet.public_2.id}"]

  enable_deletion_protection = true

  tags {
    Name = "${var.env_name} ALB"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "alb-target-group-${var.env_name}"
  port     = 80
  protocol = "HTTP"
  health_check {
    path = "/"
  }
  vpc_id   = "${aws_vpc.default.id}"
  target_type = "instance"

  tags {
    Name = "${var.env_name} ALB target group"
  }
}

resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = "${aws_lb_target_group.test.arn}"
  target_id        = "${aws_instance.web1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = "${aws_lb_target_group.test.arn}"
  target_id        = "${aws_instance.web2.id}"
  port             = 80
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = "${aws_lb.test.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.test.arn}"
    type             = "forward"
  }
}
