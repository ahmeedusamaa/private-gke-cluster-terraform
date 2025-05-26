resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1-c"
  
  network    = var.vpc_id
  subnetwork = var.restricted_subnet_name

  initial_node_count  = 2
  deletion_protection = false

  #  The private_cluster_config block supports:
  #    enable_private_nodes (Optional) - Enables the private cluster feature, creating a private endpoint on the cluster. In a private cluster, nodes only have RFC 1918 private addresses and communicate with the master's private endpoint via private networking.
  #    enable_private_endpoint (Optional) - When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. When false, either endpoint can be used. This field only applies to private clusters, when enable_private_nodes is true.
  #    master_ipv4_cidr_block (Optional) - The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet. See Private Cluster Limitations for more details. This field only applies to private clusters, when enable_private_nodes is true.
  #    private_endpoint_subnetwork - (Optional) Subnetwork in cluster's network where master's endpoint will be provisioned.
  #    master_global_access_config (Optional) - Controls cluster master global access settings. If unset, Terraform will no longer manage this field and will not modify the previously-set value. Structure is documented below.

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_subnet_cidr
      display_name = "Management Subnet"
    }
  }

}



resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = "us-central1-c"
  cluster    = google_container_cluster.primary.name
  node_count = 1  # Fixed size

  node_config {
    machine_type    = "e2-small"
    service_account = var.gke_service_account_email
    disk_size_gb    = 20
    preemptible = true
    tags            = ["restricted-node"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

