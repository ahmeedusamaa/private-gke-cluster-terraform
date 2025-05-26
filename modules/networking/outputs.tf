output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "management_subnet_name" {
  value = google_compute_subnetwork.management.name
}

output "management_subnet_cidr" {
  value = google_compute_subnetwork.management.ip_cidr_range
}
output "restricted_subnet_id" {
  value = google_compute_subnetwork.restricted.id
}
output "restricted_subnet_name" {
  value = google_compute_subnetwork.restricted.name
}