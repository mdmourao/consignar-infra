# Consignar.pt Infra Managed With Terraform

[API REST](https://rest.consignar.pt)  
[WEB](https://consignar.pt)  
[WEB 2.0](https://web.consignar.pt)  
[WEB 3.0](https://www.consignar.pt)  

## Deployed Infrastructure

![GCP Architecture](./architecture.png)

## Costs By Infracost

Note: some units are not correct (real prod costs: 30$)

Project: main-prod

 Name                                                                   Monthly Qty  Unit          Monthly Cost    
                                                                                                                   
 module.network.google_compute_global_forwarding_rule.default                                                      
 ├─ Forwarding rules                                                            730  hours                $7.30    
 └─ Ingress data                                                                625  GB                   $5.00  * 
                                                                                                                   
 module.network.google_compute_global_forwarding_rule.https_redirect                                               
 ├─ Forwarding rules                                                            730  hours                $7.30    
 └─ Ingress data                                                                625  GB                   $5.00  * 
                                                                                                                   
 module.network.google_compute_router_nat.nat                                                                      
 ├─ Assigned VMs (first 32)                                                   2,920  VM-hours             $4.09  *   
 └─ Data processed                                                              111  GB                   $5.00  * 
                                                                                                                   
 module.network.google_compute_global_address.default                                                              
 └─ IP address                                                                  730  hours                $0.00    
                                                                                                                   
 module.compute_engine.google_compute_instance.this                                                                
 ├─ Instance usage (Linux/UNIX, on-demand, e2-micro)                            730  hours                $0.00 (Free Tier)   
 └─ Standard provisioned storage (pd-standard)                                   10  GB                   $0.00 (Free Tier)     
                                                                                                                   
 module.cloud_build.google_secret_manager_secret.github-secret                                                     
 ├─ Active secret versions                                                       83  versions             $4.98  *   
 ├─ Access operations                                                         0.005  10K requests         $0.00  *   
 └─ Rotation notifications                                                        1  rotations            $0.05  * 
                                                                                                                   
 module.network.google_compute_target_http_proxy.https_redirect                                                    
 └─ Data processed                                                              625  GB                   $5.00  * 
                                                                                                                   
 module.network.google_compute_target_https_proxy.default                                                          
 └─ Data processed                                                              625  GB                   $5.00  * 
                                                                                                                   
 module.repository.google_artifact_registry_repository.this                                                        
 └─ Storage                                                                      50  GB                   $5.00  * 
                                                                                                                   
 module.cloud_build.google_secret_manager_secret_version.github-secret                                             
 ├─ Active secret versions                                                        1  versions             $0.06    
 └─ Access operations                                                         0.005  10K requests         $0.00  * 
                                                                                                                   

*Usage costs were estimated using Infracost Cloud settings

36 cloud resources were detected:  
∙ 10 were estimated  
∙ 19 were free  
∙ 7 are not supported yet  

Baseline cost $28   
Usage cost $39  
 
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.29.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_build"></a> [cloud\_build](#module\_cloud\_build) | ./modules/cloud_build | 0.1.2 |
| <a name="module_cloud_run"></a> [cloud\_run](#module\_cloud\_run) | ./modules/cloud_run | 0.1.1 |
| <a name="module_compute_engine"></a> [compute\_engine](#module\_compute\_engine) | ./modules/compute_engine | 0.3.2 |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | 0.2.1 |
| <a name="module_repository"></a> [repository](#module\_repository) | ./modules/repository | 0.0.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_consignar_certificate_path"></a> [consignar\_certificate\_path](#input\_consignar\_certificate\_path) | Consignar Certificate Path | `string` | n/a | yes |
| <a name="input_consignar_domain"></a> [consignar\_domain](#input\_consignar\_domain) | Consignar Main Domain | `string` | `"consignar.pt"` | no |
| <a name="input_consignar_private_key_path"></a> [consignar\_private\_key\_path](#input\_consignar\_private\_key\_path) | Consignar Private Key Path | `string` | n/a | yes |
| <a name="input_consignar_rest_domain"></a> [consignar\_rest\_domain](#input\_consignar\_rest\_domain) | Consignar REST Domain | `string` | `"rest.consignar.pt"` | no |
| <a name="input_consignar_web_domain"></a> [consignar\_web\_domain](#input\_consignar\_web\_domain) | Consignar Web Domain | `string` | `"web.consignar.pt"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Database Password | `string` | n/a | yes |
| <a name="input_github_app_installation_id"></a> [github\_app\_installation\_id](#input\_github\_app\_installation\_id) | GitHub App installation id | `number` | n/a | yes |
| <a name="input_github_client_secret_data"></a> [github\_client\_secret\_data](#input\_github\_client\_secret\_data) | GitHub Client Secret Data | `any` | n/a | yes |
| <a name="input_github_repository_uri"></a> [github\_repository\_uri](#input\_github\_repository\_uri) | GitHub Repository URI | `string` | n/a | yes |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | IP Range | `string` | `"10.7.0.0/16"` | no |
| <a name="input_irs_api_name"></a> [irs\_api\_name](#input\_irs\_api\_name) | Consignar REST API Image Name | `string` | `"irs-api-internal"` | no |
| <a name="input_irs_api_port"></a> [irs\_api\_port](#input\_irs\_api\_port) | Port number the IRS API listens on | `number` | `50007` | no |
| <a name="input_irs_ui_name"></a> [irs\_ui\_name](#input\_irs\_ui\_name) | Consignar Image Name | `string` | `"irs-ui-internal"` | no |
| <a name="input_irs_ui_port"></a> [irs\_ui\_port](#input\_irs\_ui\_port) | Port number the IRS UI listens on | `number` | `8080` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | DB Machine Type | `string` | `"e2-micro"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | Project Number | `number` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Deploy region | `string` | `"us-central1"` | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | Repository ID | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Deploy Zone | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_internal_ip"></a> [db\_internal\_ip](#output\_db\_internal\_ip) | The internal IP of the database instance |
<!-- END_TF_DOCS -->
