output "bastion_ip" {
  value = "ssh ubuntu@${module.bastion.bastion_name}"
}
output "web_site" {
  value = "http://${module.extLB.web_site_ip}"
}
