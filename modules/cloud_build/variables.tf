variable "region" {
  description = "Deploy region"
  type        = string
}

variable "irs_ui_name" {
  description = "Consignar Image Name"
  type        = string
}

variable "irs_api_name" {
  description = "Consignar REST API Image Name"
  type        = string
}

variable "github_repository_uri" {
  description = "GitHub Repository URI"
  type        = string
}

variable "github_app_installation_id" {
  description = "GitHub App installation id"
  type        = number
}

variable "project_number" {
  description = "Project Number"
  type        = number
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "github_client_secret_data" {
  description = "GitHub Client Secret Data"
}

variable "repository_id" {
  description = "Repository ID"
  type        = string
}