module "network" {
  version      = "0.2.1"
  source       = "./modules/network"
  project_name = var.project_name
  region       = var.region

  cloud_run_rest_service = module.cloud_run.cloud_run_rest_service
  cloud_run_web_service  = module.cloud_run.cloud_run_web_service

  consignar_web_domain  = var.consignar_web_domain
  consignar_rest_domain = var.consignar_rest_domain

  consignar_domain           = var.consignar_domain
  consignar_certificate_path = var.consignar_certificate_path
  consignar_private_key_path = var.consignar_private_key_path
}

module "repository" {
  version       = "0.0.1"
  source        = "./modules/repository"
  project_name  = var.project_name
  region        = var.region
  repository_id = var.repository_id
}

module "cloud_run" {
  version       = "0.1.1"
  source        = "./modules/cloud_run"
  region        = var.region
  project_name  = var.project_name
  repository_id = var.repository_id

  irs_ui_name  = var.irs_ui_name
  irs_api_name = var.irs_api_name
  irs_ui_port  = var.irs_ui_port
  irs_api_port = var.irs_api_port

  DB_HOST     = module.compute_engine.db_internal_ip
  DB_PASSWORD = var.db_password

  network_name    = module.network.network_name
  subnetwork_name = module.network.subnetwork_name

  depends_on = [module.cloud_build, module.repository]
}

module "compute_engine" {
  version      = "0.3.2"
  source       = "./modules/compute_engine"
  zone         = var.zone
  project_name = var.project_name

  machine_type    = var.machine_type
  db_password     = var.db_password
  network_name    = module.network.network_name
  subnetwork_name = module.network.subnetwork_name
}

module "cloud_build" {
  version = "0.1.2"
  source  = "./modules/cloud_build"
  region  = var.region

  github_app_installation_id = var.github_app_installation_id
  github_client_secret_data  = var.github_client_secret_data

  github_repository_uri = var.github_repository_uri
  irs_ui_name           = var.irs_ui_name
  irs_api_name          = var.irs_api_name

  project_number = var.project_number
  project_name   = var.project_name
  repository_id  = var.repository_id

  depends_on = [module.repository]
}

output "db_internal_ip" {
  value       = module.compute_engine.db_internal_ip
  description = "The internal IP of the database instance"
}
