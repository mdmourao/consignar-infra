variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "project_number" {
  description = "Project Number"
  type        = number
}

variable "region" {
  description = "Deploy region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Deploy Zone"
  type        = string
  default     = "us-central1-a"
}

variable "irs_ui_name" {
  description = "Consignar Image Name"
  type        = string
  default     = "irs-ui-internal"
}

variable "irs_api_name" {
  description = "Consignar REST API Image Name"
  type        = string
  default     = "irs-api-internal"
}

variable "irs_api_port" {
  description = "Port number the IRS API listens on"
  type        = number
  default     = 50007
}

variable "irs_ui_port" {
  description = "Port number the IRS UI listens on"
  type        = number
  default     = 8080
}

variable "github_repository_uri" {
  description = "GitHub Repository URI"
  type        = string
}

variable "github_app_installation_id" {
  description = "GitHub App installation id"
  type        = number
}

variable "github_client_secret_data" {
  description = "GitHub Client Secret Data"
}

variable "db_password" {
  description = "Database Password"
  type        = string
}

variable "machine_type" {
  description = "DB Machine Type"
  type        = string
  default     = "e2-micro"
}

variable "repository_id" {
  description = "Repository ID"
  type        = string
}

variable "consignar_web_domain" {
  description = "Consignar Web Domain"
  type        = string
  default     = "web.consignar.pt"
}

variable "consignar_rest_domain" {
  description = "Consignar REST Domain"
  type        = string
  default     = "rest.consignar.pt"
}

variable "consignar_domain" {
  description = "Consignar Main Domain"
  type        = string
  default     = "consignar.pt"
}

variable "consignar_private_key_path" {
  description = "Consignar Private Key Path"
  type        = string
}

variable "consignar_certificate_path" {
  description = "Consignar Certificate Path"
  type        = string
}

variable "ip_cidr_range" {
  description = "IP Range"
  type        = string
  default     = "10.7.0.0/16"
}