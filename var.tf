variable "accesskey" {
  default = "xxxxx"
}

variable "secreatkey" {
  default = "xxxxx"
}

variable "ami_id" {
  default = "ami-0bdf93799014acdc4"
}

variable "keyname" {
  default = "test"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "region" {
  default = "eu-central-1"
}

variable "cidr" {
  default = "50.13.100.0/24"
}

variable "public_subnet1" {
  default = "50.13.100.0/26"
}

variable "public_subnet2" {
  default = "50.13.100.64/26"
}

variable "private_subnet1" {
  default = "50.13.100.128/26"
}

variable "private_subnet2" {
  default = "50.13.100.192/26"
}
