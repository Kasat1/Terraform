resource "google_compute_instance_template" "default" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."
  tags = ["private"]
  instance_description = "description assigned to instances"
  machine_type         = var.machine_type # "f1-micro" #################################3
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  service_account {
    email  = "sql-816@final-test-kasat.iam.gserviceaccount.com"
  scopes = ["cloud-platform"]
  }

  // Create a new boot disk from an image
  disk {
    source_image = "ubuntu-2004-lts"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork         = var.private-subnet-name      #########################33google_compute_subnetwork.private-subnet.name
    subnetwork_project = var.project                       ################
    # access_config {           ##### if we need externalIp enable? else delete it "access_config {}""
    # }                         #####                                              -
  }
  metadata_startup_script = file("bestart")
}
resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "8080"
  }
}

resource "google_compute_region_instance_group_manager" "appserver" {
  name =  var.instnce_group_name_backend  ###"appserver-igm" 
  base_instance_name        = "app"
  region                    = "us-central1"
  distribution_policy_zones = ["us-central1-a", "us-central1-b", "us-central1-c"]

  version {
    instance_template = google_compute_instance_template.default.id
  }

  target_size = 2 #### cannot create more  instance

     named_port {
       name = "tomcat"
       port = 8080
     }
     named_port {
    name = "ssh"
    port = "22"
  }
     named_port {
    name = "sql"
    port = "5432"
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = "l7-ilb-proxy-subnet"
  project = var.project
  provider      = google-beta
  ip_cidr_range = "10.4.0.0/24"
  region        = var.region
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = var.vpc_name
}
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
    project = var.project
  name                  = "l7-ilb-forwarding-rule1"
  provider              = google-beta
  region                = var.region
  depends_on            = [google_compute_subnetwork.proxy_subnet]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "8080"
  target                = google_compute_region_target_http_proxy.default1.id
  network               = var.vpc_name
  subnetwork            = var.private_subnet_name
  network_tier          = "PREMIUM"
}
# HTTP target proxy
resource "google_compute_region_target_http_proxy" "default1" {
    project = var.project
  name     = "l7-ilb-target-http-proxy"
  provider = google-beta
  region   = var.region
  url_map  = google_compute_region_url_map.default1.id
}
# URL map
resource "google_compute_region_url_map" "default1" {
    project = var.project
  name            = "l7-ilb-regional-url-map"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.default1.id
}
# backend service
resource "google_compute_region_backend_service" "default1" {
    project = var.project
  name                  = "l7-ilb-backend-subnet"
  provider              = google-beta
  region                = var.region
  port_name = "tomcat" #google_compute_region_instance_group_manager.appserver.named_port[0].name
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default1.id]
  backend {
    group           = google_compute_region_instance_group_manager.appserver.instance_group  ###google_compute_region_instance_group_manager.mig.
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
# health check
resource "google_compute_region_health_check" "default1" {
    project = var.project
  name     = "l7-ilb-hc"
  provider = google-beta
  region   = var.region
  http_health_check {
    port = "8080"
    request_path       = "/"
  }
}
