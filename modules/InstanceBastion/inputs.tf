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
variable "bastion_name" {
  type    = string
  default = "bastion"
}
 variable "machine_type" {
  type    = string
  default = "f1-micro"
}
 variable "public_subnet_name" {
   type    = string
   default = "public-subnet"   #  module.networks.public-subnet-name     #########################link for module############### 
 }