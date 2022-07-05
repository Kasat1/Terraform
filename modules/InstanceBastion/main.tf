resource "google_compute_instance" "bastion" {
  name         = var.bastion_name
  machine_type =  var.machine_type #"f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork         = var.public_subnet_name
    subnetwork_project = var.project
    access_config {
    }
  }
  tags                    = ["public", "private"]
  #metadata_startup_script = file("start")
}