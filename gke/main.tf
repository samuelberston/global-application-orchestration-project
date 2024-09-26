provider "google" {
  project     = var.project_id
  region      = var.region
}

variable "project_id" {
  description = "gaop-436806"
}

variable "region" {
  description = "gaop-gke-cluster"
  default     = "us-west1"
}
