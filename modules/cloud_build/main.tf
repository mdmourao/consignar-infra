// Ref: https://github.com/apps/google-cloud-build
// Ref2: https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen#connecting_a_github_host_programmatically

// Create GitHub Secret to Add GitHub App Secret
resource "google_secret_manager_secret" "github-secret" {
  project   = var.project_name
  secret_id = "github-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github-secret" {
  secret      = google_secret_manager_secret.github-secret.id
  secret_data = var.github_client_secret_data
}

output "github_client_secret" {
  value = google_secret_manager_secret_version.github-secret.id
}

data "google_iam_policy" "p4sa-secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github-secret.project
  secret_id   = google_secret_manager_secret.github-secret.id
  policy_data = data.google_iam_policy.p4sa-secretAccessor.policy_data

}

// Setup GitHub connection to trigger build on commit
resource "google_cloudbuildv2_connection" "github-connection" {
  location = var.region
  name     = "github-connection"

  github_config {
    app_installation_id = var.github_app_installation_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github-secret.id
    }
  }

  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

resource "google_cloudbuildv2_repository" "irs-ui-repo" {
  location          = var.region
  name              = "${var.irs_ui_name}-repo"
  parent_connection = google_cloudbuildv2_connection.github-connection.id
  remote_uri        = "${var.github_repository_uri}${var.irs_ui_name}.git"
}

resource "google_cloudbuildv2_repository" "irs-api-repo" {
  location          = var.region
  name              = "${var.irs_api_name}-repo"
  parent_connection = google_cloudbuildv2_connection.github-connection.id
  remote_uri        = "${var.github_repository_uri}${var.irs_api_name}.git"
}

resource "google_project_iam_binding" "roles_run_admin_binding" {
  project = var.project_name
  role    = "roles/run.admin"
  members = ["serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"]
}

resource "google_project_iam_binding" "roles_service_account_user_binding" {
  project = var.project_name
  role    = "roles/iam.serviceAccountUser"
  members = ["serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"]
}

// Trigger build on commit
resource "google_cloudbuild_trigger" "irs-ui-repo-trigger" {
  name     = "${var.irs_ui_name}-trigger"
  location = var.region

  repository_event_config {
    repository = google_cloudbuildv2_repository.irs-ui-repo.id
    push {
      branch = "main"
    }
  }

  build {
    step {
      id   = "Build"
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "--no-cache", "-t", "${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_ui_name}:latest", "."]
    }
    step {
      id   = "Push"
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_ui_name}:latest"]
    }
    step {
      id         = "Deploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk:slim"
      entrypoint = "gcloud"
      args       = ["run", "services", "update", "${var.irs_ui_name}", "--platform=managed", "--image=${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_ui_name}:latest", "--labels=managed-by=gcp-cloud-build-deploy-cloud-run,commit-sha=$COMMIT_SHA,gcb-build-id=$BUILD_ID", "--region=${var.region}", "--quiet"]
    }
  }

}

// Trigger build on commit
resource "google_cloudbuild_trigger" "irs-api-repo-trigger" {
  name     = "${var.irs_api_name}-trigger"
  location = var.region

  repository_event_config {
    repository = google_cloudbuildv2_repository.irs-api-repo.id
    push {
      branch = "main"
    }
  }

  build {
    step {
      id   = "Build"
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "--no-cache", "-t", "${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_api_name}:latest", "."]
    }
    step {
      id   = "Push"
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_api_name}:latest"]
    }
    step {
      id         = "Deploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk:slim"
      entrypoint = "gcloud"
      args       = ["run", "services", "update", "${var.irs_api_name}", "--platform=managed", "--image=${var.region}-docker.pkg.dev/${var.project_name}/${var.repository_id}/${var.irs_api_name}:latest", "--labels=managed-by=gcp-cloud-build-deploy-cloud-run,commit-sha=$COMMIT_SHA,gcb-build-id=$BUILD_ID", "--region=${var.region}", "--quiet"]
    }
  }
}
