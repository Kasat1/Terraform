resource "google_compute_instance" "nginx" {
  name         = var.nginx_instance_name
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
    # access_config {
    # }
  }
  tags                    = ["private","public"]
  metadata_startup_script = file("start")
}
resource "google_compute_instance_group" "webservers" {
  name        =  var.nginx_instance_group_name #"terraform-webservers"
  description = "Nginx web"

  instances = [
    google_compute_instance.nginx.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "22"
  }

  zone = "${var.region}-c"
}
resource "google_compute_backend_service" "default" {
  name          =  var.nginx_backend_name #"backend-service"
  health_checks = [google_compute_http_health_check.default.id]
  port_name     = google_compute_instance_group.webservers.named_port[0].name
  backend {
    group = google_compute_instance_group.webservers.id
  }
}

resource "google_compute_http_health_check" "default" {
  name               =  var.healthcheck_name #"health-check"
  request_path       = "/"
  check_interval_sec = var.healthcheck_interval_sec #1
  timeout_sec        =  var.healthcheck_timeout_sec #1
}
