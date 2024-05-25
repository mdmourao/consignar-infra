// Cloud Run: IRS UI
resource "google_cloud_run_v2_service" "irs-ui" {
  name     = var.irs_ui_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  template {
    timeout                          = "30s"
    max_instance_request_concurrency = 300

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_ui_name}:latest"
      ports {
        container_port = var.irs_ui_port
      }

      resources {
        cpu_idle = true
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = []
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth-irs-ui" {
  location = var.region

  service     = google_cloud_run_v2_service.irs-ui.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

output "cloud_run_web_service" {
  value = google_cloud_run_v2_service.irs-ui.name
}

// Cloud Run: IRS API
resource "google_cloud_run_v2_service" "irs-api" {
  name     = var.irs_api_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  template {
    timeout                          = "30s"
    max_instance_request_concurrency = 300

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    vpc_access {
      network_interfaces {
        network    = var.network_name
        subnetwork = var.subnetwork_name
      }
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_api_name}:latest"
      ports {
        container_port = var.irs_api_port
      }

      startup_probe {
        initial_delay_seconds = 5
        timeout_seconds       = 5
        failure_threshold     = 3
        http_get {
          path = "/"
          port = var.irs_api_port
        }
      }

      resources {
        cpu_idle = true
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      env {
        name  = "DB_HOST"
        value = var.DB_HOST
      }
      env {
        name  = "DB_PASSWORD"
        value = var.DB_PASSWORD
      }
    }
  }

  depends_on = []
}

resource "google_cloud_run_service_iam_policy" "noauth-irs-api" {
  location = var.region

  service     = google_cloud_run_v2_service.irs-api.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

output "cloud_run_rest_service" {
  value = google_cloud_run_v2_service.irs-api.name
}
