<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_trigger.irs-api-repo-trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuild_trigger.irs-ui-repo-trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_cloudbuildv2_connection.github-connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_connection) | resource |
| [google_cloudbuildv2_repository.irs-api-repo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_repository) | resource |
| [google_cloudbuildv2_repository.irs-ui-repo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuildv2_repository) | resource |
| [google_project_iam_binding.roles_run_admin_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.roles_service_account_user_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_secret_manager_secret.github-secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_policy) | resource |
| [google_secret_manager_secret_version.github-secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_iam_policy.p4sa-secretAccessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_app_installation_id"></a> [github\_app\_installation\_id](#input\_github\_app\_installation\_id) | GitHub App installation id | `number` | n/a | yes |
| <a name="input_github_client_secret_data"></a> [github\_client\_secret\_data](#input\_github\_client\_secret\_data) | GitHub Client Secret Data | `any` | n/a | yes |
| <a name="input_github_repository_uri"></a> [github\_repository\_uri](#input\_github\_repository\_uri) | GitHub Repository URI | `string` | n/a | yes |
| <a name="input_irs_api_name"></a> [irs\_api\_name](#input\_irs\_api\_name) | Consignar REST API Image Name | `string` | n/a | yes |
| <a name="input_irs_ui_name"></a> [irs\_ui\_name](#input\_irs\_ui\_name) | Consignar Image Name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | Project Number | `number` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Deploy region | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | Repository ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_client_secret"></a> [github\_client\_secret](#output\_github\_client\_secret) | n/a |
<!-- END_TF_DOCS -->