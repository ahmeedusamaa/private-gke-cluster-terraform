resource "google_compute_network" "vpc" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "management" {
  name                     = "mgmt-subnet"
  ip_cidr_range            = "10.1.0.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "restricted" {
  name                     = "gke-restricted-subnet"
  ip_cidr_range            = "10.2.0.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "nat-router-router"
  region  = "us-central1"
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "mgmt-nat"
  router                             = google_compute_router.router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}



resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  priority      = 65534
  source_ranges = ["10.100.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_ssh_management" {
  name    = "allow-ssh-management-subnet"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 100

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["mgmt-node"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}


resource "google_compute_firewall" "allow_gke_node_ports" {
  name    = "allow-gke-node-ports"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["10.100.0.0/16"]

  target_tags = ["restricted-node"]

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
}

resource "google_compute_firewall" "allow_ingress_http_https" {
  name    = "allow-ingress-http-https"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["restricted-node"] 

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}
