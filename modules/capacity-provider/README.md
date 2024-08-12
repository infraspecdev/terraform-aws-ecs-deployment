<!-- BEGIN_TF_DOCS -->
# capacity-provider

This sub-module creates:

1. ECS Capacity Providers with `auto_scaling_group_provider` configuration (optionally with `managed_scaling`), and
2. ECS Cluster Capacity Providers using the created ECS Capacity Providers, and with `default_capacity_provider_strategy` configuration.

## Presets

### ECS Capacity Provider

- The `managed_termination_protection` is disabled by default as recommended (which enables termination protection to container instances), and can be enabled if required. (Note: Enabling this option requires the `protect_from_scale_in` to be enabled on the Autoscaling group.)

### ECS Cluster Capacity Providers

- The `default_auto_scaling_group_arn` is a required attribute, and is used as the default Autoscaling group ARN under `auto_scaling_group_provider` configuration under each ECS Capacity Provider. The `auto_scaling_group_arn` can be overridden for individual ECS Capacity Provider if required.
- The `weight` under `default_capacity_provider_strategy` configuration is set to `1` as the default option (i.e., equal distribution of tasks in each ECS Capacity Provider), and can be overridden.
- The `base` under `default_capacity_provider_strategy` configuration is set to `0` as the default option (i.e., min. number of tasks running in each ECS Capacity Provider), and can be overridden.

## Notes

- ECS Cluster Capacity Providers utilizes all the ECS Capacity Providers that were created through the sub-module as the desired behaviour, and cannot be overridden.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

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
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | Capacity Providers to associate with the ECS Cluster. | <pre>map(object({<br>    name                   = string<br>    auto_scaling_group_arn = optional(string)<br>    managed_scaling = optional(<br>      object({<br>        instance_warmup_period    = optional(number)<br>        status                    = optional(string)<br>        target_capacity           = optional(number)<br>        minimum_scaling_step_size = optional(number)<br>        maximum_scaling_step_size = optional(number)<br>      })<br>    )<br>    managed_termination_protection = optional(string, "DISABLED")<br>    tags                           = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_default_auto_scaling_group_arn"></a> [default\_auto\_scaling\_group\_arn](#input\_default\_auto\_scaling\_group\_arn) | ARN for this Auto Scaling Group. | `string` | n/a | yes |
| <a name="input_default_capacity_provider_strategies"></a> [default\_capacity\_provider\_strategies](#input\_default\_capacity\_provider\_strategies) | (Optional) Set of capacity provider strategies to use by default for the cluster. | <pre>list(object({<br>    capacity_provider = string<br>    weight            = optional(number, 1)<br>    base              = optional(number, 0)<br>  }))</pre> | `[]` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | (Required) Name of the cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arns"></a> [arns](#output\_arns) | ARNs for this Auto Scaling Group. |
| <a name="output_ecs_cluster_capacity_providers_id"></a> [ecs\_cluster\_capacity\_providers\_id](#output\_ecs\_cluster\_capacity\_providers\_id) | Same as `cluster_name` |
| <a name="output_ids"></a> [ids](#output\_ids) | Auto Scaling Group ids. |
<!-- END_TF_DOCS -->
