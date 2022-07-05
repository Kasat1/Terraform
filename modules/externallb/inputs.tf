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
variable "http_proxy_name" {
  type    = string
  default = "test-proxy"
}
variable "url_map_name" {
  type    = string
  default = "url-map"
}
variable "backend_service_id" {
  type    = string
  default = "backend-service" #module.nginx_instance_group.backend-service-name ####
}
variable "forwarding_rule_name" {
  type    = string
  default = "forwarding-rule"
}