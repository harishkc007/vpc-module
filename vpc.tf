data "aws_availability_zones" "available" {}

# vpc
resource "aws_vpc" "demovpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "dev_vpc"
  }
}

# public subnet az1

resource "aws_subnet" "sub-public1" {
  cidr_block              = "${var.public_subnet1}"
  vpc_id                  = "${aws_vpc.demovpc.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Public_subnet1"
  }
}

#public subnet2 AZ2

resource "aws_subnet" "sub-public2" {
  cidr_block              = "${var.public_subnet2}"
  vpc_id                  = "${aws_vpc.demovpc.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Public_subnet2"
  }
}

#private subnet1 AZ1
resource "aws_subnet" "sub-private1" {
  cidr_block        = "${var.private_subnet1}"
  vpc_id            = "${aws_vpc.demovpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "private_subnet1"
  }
}

#private subnet2 AZ2
resource "aws_subnet" "sub-private2" {
  cidr_block        = "${var.private_subnet2}"
  vpc_id            = "${aws_vpc.demovpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "private_subnet2"
  }
}

#internate gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.demovpc.id}"

  tags {
    Name = "Dev_igw"
  }
}

#nat gateway eip

resource "aws_eip" "nat_ip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]

  tags {
    Name = "natip"
  }
}

# NAT gateway for private ip address
resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.nat_ip.id}"
  subnet_id     = "${aws_subnet.sub-public1.id}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags {
    Name = "demo-igw"
  }
}

# Route Table for public Architecture

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.demovpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "route-pub"
  }
}

# Route table for Private subnets

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.demovpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags {
    Name = "route-pvt"
  }
}

# Route Table association with public subnets
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = "${aws_subnet.sub-public1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = "${aws_subnet.sub-public2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Route table association with private subnets
resource "aws_route_table_association" "to_private_subnet1" {
  subnet_id      = "${aws_subnet.sub-private1.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "to_private_subnet2" {
  subnet_id      = "${aws_subnet.sub-private2.id}"
  route_table_id = "${aws_route_table.private.id}"
}
