resource "google_compute_global_address" "default" {
  project  = var.project
  #provider = google-beta
  name     = "global-ip" 
}
resource "google_compute_target_http_proxy" "default" {
  name    =var.http_proxy_name ### "test-proxy" 
  url_map = google_compute_url_map.default.id
}
resource "google_compute_url_map" "default" {
  name            =  var.url_map_name ###"url-map"
  default_service = var.backend_service_id
  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = var.backend_service_id ###

    path_rule {
      paths   = ["/*"]
      service = var.backend_service_id
    }
  }
}
resource "google_compute_global_forwarding_rule" "default" {
  project = var.project
  name                  = var.forwarding_rule_name ###"forwarding-rule" 
 # provider              = google-beta
  #ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id

}
