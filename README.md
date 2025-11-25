<!-- BEGIN_TF_DOCS -->
# terraform-aws-ecs-deployment

Terraform module to deploy production-ready applications and services on an existing ECS infra.

## Architecture Diagram

![ECS Deployment Architecture Diagram](https://github.com/infraspecdev/terraform-aws-ecs-deployment/raw/main/diagrams/ecs-deployment-architecture.jpeg)

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
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | ./modules/s3-bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificates"></a> [acm\_certificates](#input\_acm\_certificates) | ACM certificates to create. | <pre>map(object({<br/>    domain_name               = string<br/>    subject_alternative_names = optional(list(string), [])<br/>    validation_method         = optional(string, "DNS")<br/>    key_algorithm             = optional(string, "RSA_2048")<br/>    validation_option = optional(object({<br/>      domain_name       = string<br/>      validation_domain = string<br/>    }))<br/>    tags                   = optional(map(string), {})<br/>    record_zone_id         = string<br/>    record_allow_overwrite = optional(bool, true)<br/>  }))</pre> | `{}` | no |
| <a name="input_capacity_provider_default_auto_scaling_group_arn"></a> [capacity\_provider\_default\_auto\_scaling\_group\_arn](#input\_capacity\_provider\_default\_auto\_scaling\_group\_arn) | ARN for this Auto Scaling Group. | `string` | `null` | no |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | Capacity Providers to associate with the ECS Cluster. | `any` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) Name of the cluster. | `string` | n/a | yes |
| <a name="input_create_acm"></a> [create\_acm](#input\_create\_acm) | Creates the ACM certificates to use with the Load Balancer. | `bool` | `false` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Creates a new Application Load Balancer to use with the ECS Service. | `bool` | `true` | no |
| <a name="input_create_capacity_provider"></a> [create\_capacity\_provider](#input\_create\_capacity\_provider) | Creates a new Capacity Provider to use with the Autoscaling Group. | `bool` | `true` | no |
| <a name="input_create_s3_bucket_for_alb_logging"></a> [create\_s3\_bucket\_for\_alb\_logging](#input\_create\_s3\_bucket\_for\_alb\_logging) | (Optional) Creates S3 bucket for storing ALB Access and Connection Logs. | `bool` | `true` | no |
| <a name="input_default_capacity_providers_strategies"></a> [default\_capacity\_providers\_strategies](#input\_default\_capacity\_providers\_strategies) | (Optional) Set of capacity provider strategies to use by default for the cluster. | `any` | `[]` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Configuration for the Application Load Balancer. | <pre>object({<br/>    name                       = optional(string)<br/>    internal                   = optional(bool, false)<br/>    subnets_ids                = optional(list(string), [])<br/>    security_groups_ids        = optional(list(string), [])<br/>    preserve_host_header       = optional(bool)<br/>    enable_deletion_protection = optional(bool, false)<br/>    access_logs                = optional(any, null)<br/>    connection_logs            = optional(any, null)<br/>    target_groups              = optional(any, {})<br/>    listeners                  = optional(any, {})<br/>    listener_rules             = optional(any, {})<br/>    tags                       = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | (Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | (Optional, Forces new resource) Name of the bucket. | `string` | `null` | no |
| <a name="input_s3_bucket_policy_id_prefix"></a> [s3\_bucket\_policy\_id\_prefix](#input\_s3\_bucket\_policy\_id\_prefix) | (Optional) - Prefix of the ID for the policy document. | `string` | `"ecs-deployment-alb-"` | no |
| <a name="input_s3_bucket_tags"></a> [s3\_bucket\_tags](#input\_s3\_bucket\_tags) | (Optional) Map of tags to assign to the bucket. | `map(string)` | `{}` | no |
| <a name="input_s3_elb_service_account_arn"></a> [s3\_elb\_service\_account\_arn](#input\_s3\_elb\_service\_account\_arn) | (Optional, Default:null) ARN of the ELB Service Account. | `string` | `null` | no |
| <a name="input_service"></a> [service](#input\_service) | Configuration for ECS Service. | <pre>object({<br/>    name                               = string<br/>    deployment_maximum_percent         = optional(number)<br/>    deployment_minimum_healthy_percent = optional(number)<br/>    desired_count                      = optional(number)<br/>    enable_ecs_managed_tags            = optional(bool, true)<br/>    enable_execute_command             = optional(bool)<br/>    force_new_deployment               = optional(bool, true)<br/>    health_check_grace_period_seconds  = optional(number)<br/>    iam_role                           = optional(string)<br/>    propagate_tags                     = optional(string)<br/>    scheduling_strategy                = optional(string)<br/>    triggers                           = optional(map(string))<br/>    wait_for_steady_state              = optional(bool)<br/>    load_balancer                      = optional(any, [])<br/>    network_configuration              = optional(any, null)<br/>    service_connect_configuration      = optional(any, null)<br/>    volume_configuration               = optional(any, null)<br/>    deployment_circuit_breaker         = optional(any, null)<br/>    service_registries                 = optional(any, null)<br/>    tags                               = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | ECS Task Definition to use for running tasks. | <pre>object({<br/>    container_definitions = any<br/>    family                = string<br/>    cpu                   = optional(string)<br/>    execution_role_arn    = optional(string)<br/>    ipc_mode              = optional(string)<br/>    memory                = optional(string)<br/>    network_mode          = optional(string, "awsvpc")<br/>    pid_mode              = optional(string)<br/>    skip_destroy          = optional(bool)<br/>    task_role_arn         = optional(string)<br/>    track_latest          = optional(bool)<br/>    runtime_platform      = optional(any, null)<br/>    volume                = optional(any, null)<br/>    tags                  = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_validation_id"></a> [acm\_certificate\_validation\_id](#output\_acm\_certificate\_validation\_id) | Identifiers of the ACM certificates validation resources. |
| <a name="output_acm_certificates_arns"></a> [acm\_certificates\_arns](#output\_acm\_certificates\_arns) | ARNs of the ACM certificates. |
| <a name="output_acm_certificates_ids"></a> [acm\_certificates\_ids](#output\_acm\_certificates\_ids) | Identifiers of the ACM certificates. |
| <a name="output_acm_route53_records_ids"></a> [acm\_route53\_records\_ids](#output\_acm\_route53\_records\_ids) | Identifiers of the Route53 Records for validation of the ACM certificates. |
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the load balancer. |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the load balancer. |
| <a name="output_alb_listener_rules_arns"></a> [alb\_listener\_rules\_arns](#output\_alb\_listener\_rules\_arns) | ARNs of the Listener Rules. |
| <a name="output_alb_listener_rules_ids"></a> [alb\_listener\_rules\_ids](#output\_alb\_listener\_rules\_ids) | Identifiers of the Listener Rules. |
| <a name="output_alb_listeners_arns"></a> [alb\_listeners\_arns](#output\_alb\_listeners\_arns) | ARNs of the Listeners. |
| <a name="output_alb_listeners_ids"></a> [alb\_listeners\_ids](#output\_alb\_listeners\_ids) | Identifiers of the Listeners. |
| <a name="output_alb_target_groups_arns"></a> [alb\_target\_groups\_arns](#output\_alb\_target\_groups\_arns) | ARNs of the Target Groups. |
| <a name="output_alb_target_groups_ids"></a> [alb\_target\_groups\_ids](#output\_alb\_target\_groups\_ids) | Identifiers of the Target Groups. |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | Canonical hosted zone ID of the Load Balancer. |
| <a name="output_capacity_provider_arns"></a> [capacity\_provider\_arns](#output\_capacity\_provider\_arns) | ARNs for the ECS Capacity Providers. |
| <a name="output_capacity_provider_ecs_cluster_capacity_providers_id"></a> [capacity\_provider\_ecs\_cluster\_capacity\_providers\_id](#output\_capacity\_provider\_ecs\_cluster\_capacity\_providers\_id) | Identifier for the ECS Cluster Capacity Providers. |
| <a name="output_capacity_provider_ids"></a> [capacity\_provider\_ids](#output\_capacity\_provider\_ids) | Identifiers for the ECS Capacity Providers. |
| <a name="output_ecs_service_arn"></a> [ecs\_service\_arn](#output\_ecs\_service\_arn) | ARN that identifies the service. |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | Full ARN of the Task Definition. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the bucket. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | Name of the bucket. |
<!-- END_TF_DOCS -->
