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
variable "nginx_instance_name" {
  type    = string
  default = "nginx"
}
 variable "machine_type" {
  type    = string
  default = "f1-micro"
}
 variable "public_subnet_name" {
   type    = string
   default = "public-subnet"   #  module.networks.public-subnet-name     #########################link for module############### 
 }
variable "nginx_instance_group_name" {
  type    = string
  default = "terraform-webservers"
}
variable "nginx_backend_name" {
  type    = string
  default = "backend-service"
}    
 variable "healthcheck_name" {
  type    = string
  default = "health-check"
}  
variable "healthcheck_interval_sec" {
  default = "1"
} 
variable "healthcheck_timeout_sec" {
  default = "1"
}         
