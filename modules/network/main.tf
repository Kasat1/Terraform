resource "google_compute_network" "vpc_network" {
  provider                = google-beta
  project                 = var.project
  name                    = var.name_of_vpc
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  mtu                     = 1460
}
resource "google_compute_subnetwork" "public-subnet" {
  name          = var.public_subnet_name
  ip_cidr_range = var.public_ip_cidr_range
  network       = google_compute_network.vpc_network.id
}
resource "google_compute_subnetwork" "private-subnet" {
  name          = var.private_subnet_name
  ip_cidr_range = var.private_ip_cidr_range
  network       = google_compute_network.vpc_network.id
}
resource "google_compute_firewall" "rules-first" {
  project     = var.project
  name        = "my-firewall-rule-first"
  network     = google_compute_network.vpc_network.name
  description = "Creates firewall rules for external (allow 80,22) "

  allow {
    ports    = ["80", "22"]
    protocol = "tcp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}
resource "google_compute_firewall" "rules-sec" {
  project     = var.project
  name        = "my-firewall-rule-sec"
  network     = google_compute_network.vpc_network.name
  description = "internal access (allow 0-65535) "
    allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = ["10.2.1.0/24", "10.2.2.0/24"]
  #destination_ranges = ["10.2.1.0/24", "10.2.2.0/24"]
  #source_tags = ["private"]
target_tags = ["private"]  
}
###
resource "google_compute_firewall" "rules-health-check" {
  project     = var.project
  name        = "my-firewall-rule-for-healthcheck"
  network     = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["private"]  
}
###
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = var.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
