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
  default = "future-alcove-339917"
}
variable "machine_type" {
    type = string
    default = "f1-micro"
}
variable "private-subnet-name" {
  default = "private-subnet"
}
variable "instnce_group_name_backend" {
  default = "appserver-igm"
}
variable "backend_servcier_name" {
  default = "backend-service-tomcat-sql"
}
variable "health_check_be_name" {
  default = "health-check-backend"
}

variable "vpc_name" {
  type    = string
  default = "vpc"  ###link for module
}
variable "private_subnet_name" {
  type    = string
  default = "private-subnet"  ###link_for_module
}
variable "default_backend_id" {
  type    = string
  default = "backend-service-tomcat-sql-akasatau" #module.nginx_instance_group.backend-service-name ####
}
