provider "google" {
  credentials = file("tfcred")
  project     = var.project
  region      = var.region
  zone        = var.zone
}
module "networks" {
  source = "./modules/network"
}
module "extLB" {
  source = "./modules/externallb"
}
module "nginx_instance_group" {
  source = "./modules/Instancegrp_nginx"
}
module "internalLB" {
  source = "./modules/internalLB"
}
module "bastion" {
  source = "./modules/InstanceBastion"
}
