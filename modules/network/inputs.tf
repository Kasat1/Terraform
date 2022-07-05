variable "region" {
  type    = string
  default = "us-central1"
}
variable "zone" {
  type    = string
  default = "us-central1-c"
}
variable "project" {
  type    = string
  default = "final-task-akasatau"
}
variable "name_of_vpc" {
  type    = string
  default = "vpc"
}
variable "public_subnet_name" {
  type    = string
  default = "public-subnet"
}
variable "private_subnet_name" {
  type    = string
  default = "private-subnet"
}
variable "public_ip_cidr_range" {
  type    = string
  default = "10.2.1.0/24"
}
variable "private_ip_cidr_range" {
  type    = string
  default = "10.2.2.0/24"
}