provider "aws" {
  access_key = "${var.accesskey}"
  secret_key = "${var.secreatkey}"
  region     = "${var.region}"
}

#data "aws_availability_zones" "available" {}

resource "aws_instance" "vm1" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${data.aws_availability_zones.available.names[0]}"
  key_name               = "${var.keyname}"
  subnet_id              = "${aws_subnet.sub-private1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  tags {
    Name = "appvm"
  }
}
