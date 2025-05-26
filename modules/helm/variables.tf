variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default = "my-gke-cluster"
}

variable "zone" {
  description = "The zone in which the GKE cluster will be created."
  type        = string
  default = "us-central1-c"
}

variable "project_id" {
  description = "The ID of the GCP project where the GKE cluster will be created."
  type        = string
  default = "level-agent-460100-t6"
}