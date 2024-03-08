variable "project" {
  type        = string
  description = "Project name"
  default = "gcp-helloworld-416520"
}

variable "env" {
  type  = string
  description = "Environment prefix to deploy to. (prod, dev, sandbox)"
}

variable "region" {
  type        = string
  default     = "us-west1"
}

variable "frontend_bucket" {
    type = string
    default = "gcp-helloworld-frontend"
}
