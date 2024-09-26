provider "google" {
  credentials = file("~/.gcp/gaop-436806-a1d06d0fe5f3.json")
  project     = var.project_id
  region      = var.region
}

variable "project_id" {
  default = "gaop-436806"
}

variable "region" {
  default = "us-west1"
}

variable "cluster_name" {
  default = "gaop-gke-cluster"
}

variable "node_count" {
  default = 2
}