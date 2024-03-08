terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.19.0"
    }
    local = {
        source = "hashicorp/local"
        version = "~> 2.4.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
}

locals {

}
