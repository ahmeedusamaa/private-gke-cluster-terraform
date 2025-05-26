variable "project_id" {
  description = "The ID of the project in which the resources will be created."
  type        = string
  
}

variable "region" {
  description = "The region where the GKE cluster will be created."
  type        = string
  default     = "us-central1"
}