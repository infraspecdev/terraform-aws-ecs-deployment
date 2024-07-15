<!-- BEGIN_TF_DOCS -->
# capacity-provider

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_capacity_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | Capacity Providers to associate with the ECS Cluster | <pre>map(object({<br>    name                   = string<br>    auto_scaling_group_arn = optional(string)<br>    managed_scaling = optional(<br>      object({<br>        instance_warmup_period    = optional(number)<br>        status                    = optional(string)<br>        target_capacity           = optional(number)<br>        minimum_scaling_step_size = optional(number)<br>        maximum_scaling_step_size = optional(number)<br>      })<br>    )<br>    tags = map(any)<br>  }))</pre> | `{}` | no |
| <a name="input_default_auto_scaling_group_arn"></a> [default\_auto\_scaling\_group\_arn](#input\_default\_auto\_scaling\_group\_arn) | Default Autoscaling group to associate with the ECS Capacity Providers | `string` | n/a | yes |
| <a name="input_default_capacity_provider_strategies"></a> [default\_capacity\_provider\_strategies](#input\_default\_capacity\_provider\_strategies) | Default Capacity Provider Strategies to use | <pre>list(object({<br>    capacity_provider = string<br>    weight            = optional(number, 0)<br>    base              = optional(number, 0)<br>  }))</pre> | `[]` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name of the ECS Cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arns"></a> [arns](#output\_arns) | ARNs for the ECS Capacity Providers |
| <a name="output_ecs_cluster_capacity_providers_id"></a> [ecs\_cluster\_capacity\_providers\_id](#output\_ecs\_cluster\_capacity\_providers\_id) | Identifier for the ECS Cluster Capacity Providers |
| <a name="output_ids"></a> [ids](#output\_ids) | Identifiers for the ECS Capacity Providers |
<!-- END_TF_DOCS -->
