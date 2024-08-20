<!-- BEGIN_TF_DOCS -->
# alb

This sub-module creates:

1. Application Load Balancer in the given subnets with logging configuration
2. Target Groups with Health Check configuration
3. Listeners with Default Action configuration, and
4. Listener Rules with Actions with `forward` and `authenticate-oidc` types, and Conditions involving `host_header`, `path_pattern`, and `http_request_method`.

## Presets

### Load Balancer

- The `internal` is set to `false` as the default option (i.e., an Internet-facing ALB), and can be overridden to be internal if required.
- The `preserve_host_header` is set to `true` as the default option (i.e., the `HOST` header is not overridden by the ALB), and can be overridden to allow the ALB to override the header if required.
- The `enable_deletion_protection` is set to `false` as the recommended option (i.e., the ALB can be destroyed using the API), and can be overridden to enable the deletion protection if required.

### Listener

- The `protocol` is set to `HTTP` as the default option, and can be overridden to use `HTTPS` if required.
- The `ssl_policy` is set to `ELBSecurityPolicy-TLS13-1-2-2021-06` as the recommended SSL policy ([read more](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies)), and can be overridden to use a different SSL policy if required.

## Notes

- For configuration that requires ARNs to other Target Groups/Listeners, the name of the Target Group/Listener can be specified as the value of the attribute, so that the sub-module implicitly references the corresponding Target Group/Listener for the ARN.

  ```hcl
  module "alb" {
    . . .

    target_groups = {
      # Define the Target Group with a key
      nginx = {
        . . .
      }
    }

    listeners = {
      . . .
      default_action = [
        {
          . . .

          # Reference the target group using the key
          target_group = "nginx"
        }
      ]
    }
  }
  ```

- Listener Rule Actions currently support the `forward` and `authenticate-oidc` types only, and will be expanded to cover other types in future iteratively. Similarly, the Listener Rule Conditions currently support the `host_header`, `path_pattern` and `http_request_method` configurations only.

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
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | (Optional) Access Logs block. | <pre>object({<br>    bucket  = string<br>    enabled = optional(bool, true)<br>    prefix  = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_connection_logs"></a> [connection\_logs](#input\_connection\_logs) | (Optional) Connection Logs block. | <pre>object({<br>    bucket  = string<br>    enabled = optional(bool, false)<br>    prefix  = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | (Optional) If true, deletion of the load balancer will be disabled via the AWS API. | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | (Optional) If true, the LB will be internal. | `bool` | `false` | no |
| <a name="input_listener_rules"></a> [listener\_rules](#input\_listener\_rules) | Listener rules to associate with the the ALB Listeners. | <pre>map(object({<br>    listener = string<br>    priority = optional(number)<br>    action = list(object({<br>      type = string<br>      authenticate_oidc = optional(object({<br>        authorization_endpoint     = string<br>        client_id                  = string<br>        client_secret              = string<br>        issuer                     = string<br>        on_unauthenticated_request = optional(string)<br>        scope                      = optional(string)<br>        session_cookie_name        = optional(string)<br>        token_endpoint             = string<br>        user_info_endpoint         = string<br>      }))<br>      target_group = optional(string)<br>    }))<br>    condition = set(object({<br>      host_header = optional(object({<br>        values = set(string)<br>      }))<br>      path_pattern = optional(object({<br>        values = set(string)<br>      }))<br>      http_request_method = optional(object({<br>        values = set(string)<br>      }))<br>    }))<br>    tags = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Listeners to forward ALB ingress to desired Target Groups. | <pre>map(object({<br>    default_action = list(object({<br>      type           = string<br>      target_group   = string<br>      fixed_response = optional(any, null)<br>      forward        = optional(any, null)<br>      order          = optional(number)<br>      redirect       = optional(any, null)<br>    }))<br>    certificate_arn = optional(string)<br>    port            = optional(number)<br>    protocol        = optional(string, "HTTP")<br>    ssl_policy      = optional(string, null)<br>    tags            = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) Name of the LB. | `string` | `null` | no |
| <a name="input_preserve_host_header"></a> [preserve\_host\_header](#input\_preserve\_host\_header) | (Optional) Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. | `bool` | `true` | no |
| <a name="input_security_groups_ids"></a> [security\_groups\_ids](#input\_security\_groups\_ids) | (Optional) List of security group IDs to assign to the LB. | `list(string)` | `[]` | no |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | (Optional) List of subnet IDs to attach to the LB. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Target Groups to create and forward ALB ingress to. | <pre>map(object({<br>    name         = optional(string)<br>    vpc_id       = optional(string)<br>    port         = optional(number)<br>    protocol     = optional(string)<br>    target_type  = optional(string)<br>    health_check = optional(any, null)<br>    tags         = optional(map(string), {})<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the load balancer. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the load balancer. |
| <a name="output_listener_rules_arns"></a> [listener\_rules\_arns](#output\_listener\_rules\_arns) | ARNs of the Listener Rules. |
| <a name="output_listener_rules_ids"></a> [listener\_rules\_ids](#output\_listener\_rules\_ids) | Identifiers of the Listener Rules. |
| <a name="output_listeners_arns"></a> [listeners\_arns](#output\_listeners\_arns) | ARNs of the Listeners. |
| <a name="output_listeners_ids"></a> [listeners\_ids](#output\_listeners\_ids) | Identifiers of the Listeners. |
| <a name="output_target_groups_arns"></a> [target\_groups\_arns](#output\_target\_groups\_arns) | ARNs of the Target Groups. |
| <a name="output_target_groups_ids"></a> [target\_groups\_ids](#output\_target\_groups\_ids) | Identifiers of the Target Groups. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Canonical hosted zone ID of the load balancer. |
<!-- END_TF_DOCS -->
