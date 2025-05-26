variable "vpc_id" {
  description = "The ID of the VPC network to which the GKE cluster will be connected."
  type        = string
}

variable "restricted_subnet_name" {
  description = "The ID of the restricted subnet for the GKE cluster."
  type        = string
}

variable "management_subnet_cidr" {
  description = "The CIDR block for the management subnet."
  type        = string
  
}

variable "gke_service_account_email" {
  description = "The email of the service account to be used by the GKE cluster."
  type        = string
  
}

variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}