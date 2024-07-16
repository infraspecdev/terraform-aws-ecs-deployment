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
| <a name="input_internal"></a> [internal](#input\_internal) | Either the ALB is internal or internet-facing | `bool` | `false` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Listeners to forward ALB ingress to desired Target Groups | <pre>list(object({<br>    default_action = list(object({<br>      type                 = string<br>      target_group         = string<br>      authenticate_cognito = optional(any, {})<br>      authenticate_oidc    = optional(any, {})<br>      fixed_response       = optional(any, {})<br>      forward              = optional(any, {})<br>      order                = optional(number)<br>      redirect             = optional(any, {})<br>    }))<br>    alpn_policy           = optional(string)<br>    certificate_arn       = optional(string)<br>    mutual_authentication = optional(any, {})<br>    port                  = optional(number)<br>    protocol              = optional(string)<br>    ssl_policy            = optional(string)<br>    tags                  = optional(map(any), {})<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the ALB | `string` | `""` | no |
| <a name="input_preserve_host_header"></a> [preserve\_host\_header](#input\_preserve\_host\_header) | Whether the ALB should preserve the Host Header in HTTP requests and send it to the target without any changes | `bool` | `false` | no |
| <a name="input_security_groups_ids"></a> [security\_groups\_ids](#input\_security\_groups\_ids) | Identifiers of Security Groups for the ALB | `list(string)` | `[]` | no |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | Identifiers of the VPC Subnets where the ALB will be active | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource Tags for the ALB | `map(any)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Target Groups to create and forward ALB ingress to | <pre>map(object({<br>    name         = optional(string)<br>    vpc_id       = optional(string)<br>    port         = optional(number)<br>    protocol     = optional(string)<br>    target_type  = optional(string)<br>    health_check = optional(any, {})<br>    tags         = optional(map(any), {})<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Load Balancer |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the Load Balancer |
| <a name="output_id"></a> [id](#output\_id) | Identifier of the Load Balancer |
| <a name="output_listeners_arns"></a> [listeners\_arns](#output\_listeners\_arns) | ARNs of the Listeners |
| <a name="output_listeners_ids"></a> [listeners\_ids](#output\_listeners\_ids) | Identifiers of the Listeners |
| <a name="output_target_groups_arns"></a> [target\_groups\_arns](#output\_target\_groups\_arns) | ARNs of the Target Groups |
| <a name="output_target_groups_ids"></a> [target\_groups\_ids](#output\_target\_groups\_ids) | Identifiers of the Target Groups |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Canonical hosted zone ID of the Load Balancer (to be used in a Route 53 Alias record) |
<!-- END_TF_DOCS -->
