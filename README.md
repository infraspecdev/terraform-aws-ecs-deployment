<!-- BEGIN_TF_DOCS -->
# terraform-aws-ecs-deployment

Terraform module to deploy production-ready applications and services on an existing ECS infra.

## Architecture Diagram

![ECS Deployment Architecture Diagram](./diagrams/ecs-deployment-diagram.jpeg)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ./modules/acm | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_capacity_provider"></a> [capacity\_provider](#module\_capacity\_provider) | ./modules/capacity-provider | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_amazon_issued_certificates"></a> [acm\_amazon\_issued\_certificates](#input\_acm\_amazon\_issued\_certificates) | Amazon-issued ACM certificates to create. | `any` | `{}` | no |
| <a name="input_acm_imported_certificates"></a> [acm\_imported\_certificates](#input\_acm\_imported\_certificates) | Imported ACM certificates to create. | `any` | `{}` | no |
| <a name="input_capacity_provider_default_auto_scaling_group_arn"></a> [capacity\_provider\_default\_auto\_scaling\_group\_arn](#input\_capacity\_provider\_default\_auto\_scaling\_group\_arn) | ARN for this Auto Scaling Group. | `string` | `null` | no |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | Capacity Providers to associate with the ECS Cluster. | `any` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) Name of the cluster. | `string` | n/a | yes |
| <a name="input_create_acm"></a> [create\_acm](#input\_create\_acm) | Creates the ACM certificates to use with the Load Balancer. | `bool` | `false` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Creates a new Application Load Balancer to use with the ECS Service. | `bool` | `true` | no |
| <a name="input_create_capacity_provider"></a> [create\_capacity\_provider](#input\_create\_capacity\_provider) | Creates a new Capacity Provider to use with the Autoscaling Group. | `bool` | `true` | no |
| <a name="input_default_capacity_providers_strategies"></a> [default\_capacity\_providers\_strategies](#input\_default\_capacity\_providers\_strategies) | (Optional) Set of capacity provider strategies to use by default for the cluster. | `any` | `[]` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Configuration for the Application Load Balancer. | `any` | `{}` | no |
| <a name="input_service"></a> [service](#input\_service) | Configuration for ECS Service. | `any` | n/a | yes |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | ECS Task Definition to use for running tasks. | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the load balancer. |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the load balancer. |
| <a name="output_alb_listeners_arns"></a> [alb\_listeners\_arns](#output\_alb\_listeners\_arns) | ARNs of the Listeners. |
| <a name="output_alb_listeners_ids"></a> [alb\_listeners\_ids](#output\_alb\_listeners\_ids) | Identifiers of the Listeners. |
| <a name="output_alb_target_groups_arns"></a> [alb\_target\_groups\_arns](#output\_alb\_target\_groups\_arns) | ARNs of the Target Groups. |
| <a name="output_alb_target_groups_ids"></a> [alb\_target\_groups\_ids](#output\_alb\_target\_groups\_ids) | Identifiers of the Target Groups. |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | Canonical hosted zone ID of the Load Balancer. |
| <a name="output_amazon_issued_acm_certificates_arns"></a> [amazon\_issued\_acm\_certificates\_arns](#output\_amazon\_issued\_acm\_certificates\_arns) | ARNs of the Amazon issued ACM certificates. |
| <a name="output_amazon_issued_acm_certificates_validation_records"></a> [amazon\_issued\_acm\_certificates\_validation\_records](#output\_amazon\_issued\_acm\_certificates\_validation\_records) | Validation Records of the Amazon issued ACM certificates. |
| <a name="output_capacity_provider_arns"></a> [capacity\_provider\_arns](#output\_capacity\_provider\_arns) | ARNs for the ECS Capacity Providers. |
| <a name="output_capacity_provider_ecs_cluster_capacity_providers_id"></a> [capacity\_provider\_ecs\_cluster\_capacity\_providers\_id](#output\_capacity\_provider\_ecs\_cluster\_capacity\_providers\_id) | Identifier for the ECS Cluster Capacity Providers. |
| <a name="output_capacity_provider_ids"></a> [capacity\_provider\_ids](#output\_capacity\_provider\_ids) | Identifiers for the ECS Capacity Providers. |
| <a name="output_ecs_service_arn"></a> [ecs\_service\_arn](#output\_ecs\_service\_arn) | ARN that identifies the service. |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | Full ARN of the Task Definition. |
| <a name="output_imported_acm_certificates_arns"></a> [imported\_acm\_certificates\_arns](#output\_imported\_acm\_certificates\_arns) | ARNs of the Imported ACM certificates. |
<!-- END_TF_DOCS -->
