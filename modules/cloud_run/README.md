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
| [google_cloud_run_service_iam_policy.noauth-irs-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloud_run_service_iam_policy.noauth-irs-ui](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloud_run_v2_service.irs-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service.irs-ui](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_DB_HOST"></a> [DB\_HOST](#input\_DB\_HOST) | Database Host | `string` | n/a | yes |
| <a name="input_DB_PASSWORD"></a> [DB\_PASSWORD](#input\_DB\_PASSWORD) | Database Password | `string` | n/a | yes |
| <a name="input_irs_api_name"></a> [irs\_api\_name](#input\_irs\_api\_name) | Consignar REST API Image Name | `string` | n/a | yes |
| <a name="input_irs_api_port"></a> [irs\_api\_port](#input\_irs\_api\_port) | Port number the IRS API listens on | `number` | n/a | yes |
| <a name="input_irs_ui_name"></a> [irs\_ui\_name](#input\_irs\_ui\_name) | Consignar Image Name | `string` | n/a | yes |
| <a name="input_irs_ui_port"></a> [irs\_ui\_port](#input\_irs\_ui\_port) | Port number the IRS UI listens on | `number` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the network | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Deploy region | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | Repository ID | `string` | n/a | yes |
| <a name="input_subnetwork_name"></a> [subnetwork\_name](#input\_subnetwork\_name) | Name of the subnetwork | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_run_rest_service"></a> [cloud\_run\_rest\_service](#output\_cloud\_run\_rest\_service) | n/a |
| <a name="output_cloud_run_web_service"></a> [cloud\_run\_web\_service](#output\_cloud\_run\_web\_service) | n/a |
<!-- END_TF_DOCS -->