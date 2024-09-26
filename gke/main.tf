provider "google" {
  project     = var.project_id
  region      = var.region
}

variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The region for the GKE cluster"
  default     = "us-central1" # Change to your preferred region
}
