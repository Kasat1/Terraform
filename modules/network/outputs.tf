output "vpc-name" {
  value = google_compute_network.vpc_network.name
}
output "vpc-id" {
  value = google_compute_network.vpc_network.id
}
output "public-subnet-name" {
  value= google_compute_subnetwork.public-subnet.name
}
output "private-subnet-name" {
  value = google_compute_subnetwork.private-subnet.name
}