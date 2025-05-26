resource "google_service_account" "vm_sa" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_project_iam_member" "vm_sa_roles" {
  for_each = toset([
    "roles/container.developer",
    "roles/container.clusterAdmin",
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountUser"
  ])
  
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_compute_instance" "default" {
  name         = "management-instance"
  machine_type = "e2-medium" 
  zone         = "us-central1-a"

  tags = [
    "mgmt-node",  # Tag for firewall rules applied to management subnet VMs
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.management_subnet_name
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}