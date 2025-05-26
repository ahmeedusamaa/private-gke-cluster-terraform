variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "management_subnet_name" {
  description = "The name of the management subnet."
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}