locals {
  bucket_prefix = "${var.env}-${var.project}"
  bucket_name = "${local.bucket_prefix}-frontend"
  backend_name = "${local.bucket_prefix}-frontend-cdn"
  map_name = "${local.bucket_prefix}-frontend-map"
}

resource "google_storage_bucket" "frontend-content" {
  name          = local.bucket_name
  location      = "US"
  force_destroy = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.frontend-content.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.frontend-content.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "google_compute_backend_bucket" "static-frontend" {
  name        = local.backend_name
  bucket_name = google_storage_bucket.frontend-content.name

  enable_cdn = false
}
resource "google_compute_url_map" "url-map" {
  name            = local.map_name
  default_service = google_compute_backend_bucket.static-frontend.self_link
}
resource "google_compute_target_http_proxy" "http-proxy" {
  name    = "${local.bucket_prefix}-proxy"
  url_map = google_compute_url_map.url-map.self_link
}
resource "google_compute_global_forwarding_rule" "default" {
  name       = "${local.bucket_prefix}-http"
  target     = google_compute_target_http_proxy.http-proxy.self_link
  port_range = "80"
}

output "url" {
  description = "Website URL"
  value       = google_storage_bucket.frontend-content.self_link
}

resource "local_file" "bucket_url_file" {
  depends_on = [google_storage_bucket.frontend-content]

  filename = "${path.module}/var/bucket_url.txt"
  content  = "${google_storage_bucket.frontend-content.url}"
}
