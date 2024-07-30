<!-- BEGIN_TF_DOCS -->
# alb

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
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | (Optional) If true, deletion of the load balancer will be disabled via the AWS API. | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | (Optional) If true, the LB will be internal. | `bool` | `false` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Listeners to forward ALB ingress to desired Target Groups. | <pre>map(object({<br>    default_action = list(object({<br>      type           = string<br>      target_group   = string<br>      fixed_response = optional(any, null)<br>      forward        = optional(any, null)<br>      order          = optional(number)<br>      redirect       = optional(any, null)<br>    }))<br>    certificate_arn = optional(string)<br>    port            = optional(number)<br>    protocol        = optional(string)<br>    ssl_policy      = optional(string)<br>    tags            = optional(map(string), {})<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Optional) Name of the LB. | `string` | `""` | no |
| <a name="input_preserve_host_header"></a> [preserve\_host\_header](#input\_preserve\_host\_header) | (Optional) Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. | `bool` | `false` | no |
| <a name="input_security_groups_ids"></a> [security\_groups\_ids](#input\_security\_groups\_ids) | (Optional) List of security group IDs to assign to the LB. | `list(string)` | `[]` | no |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | (Optional) List of subnet IDs to attach to the LB. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Target Groups to create and forward ALB ingress to. | <pre>map(object({<br>    name         = optional(string)<br>    vpc_id       = optional(string)<br>    port         = optional(number)<br>    protocol     = optional(string)<br>    target_type  = optional(string)<br>    health_check = optional(any, null)<br>    tags         = optional(map(string), {})<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the load balancer. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the load balancer. |
| <a name="output_listeners_arns"></a> [listeners\_arns](#output\_listeners\_arns) | ARNs of the Listeners. |
| <a name="output_listeners_ids"></a> [listeners\_ids](#output\_listeners\_ids) | Identifiers of the Listeners. |
| <a name="output_target_groups_arns"></a> [target\_groups\_arns](#output\_target\_groups\_arns) | ARNs of the Target Groups. |
| <a name="output_target_groups_ids"></a> [target\_groups\_ids](#output\_target\_groups\_ids) | Identifiers of the Target Groups. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Canonical hosted zone ID of the load balancer. |
<!-- END_TF_DOCS -->
