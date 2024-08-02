<!-- BEGIN_TF_DOCS -->
# acm

This sub-module creates the Amazon-issued certificates for given domains with `validation_option` configuration.

## Presets

- The `validation_method` is set to `DNS` as the recommended method, and can be overridden to use `EMAIL` method if required.

## Notes

- ACM certificates are created before destroying existing ones (to update the configuration), which is the recommended practice.
- The sub-module outputs the corresponding validation records for every Amazon-issued ACM certificate created. This can be further used to complete the validation by creating the Route53 DNS records.

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
| [aws_acm_certificate.amazon_issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_issued_certificates"></a> [amazon\_issued\_certificates](#input\_amazon\_issued\_certificates) | List of Amazon-issued certificates to ACM create. | <pre>map(object({<br>    domain_name               = string<br>    subject_alternative_names = optional(list(string), [])<br>    validation_method         = optional(string, "DNS")<br>    key_algorithm             = optional(string, null)<br>    validation_option = optional(object({<br>      domain_name       = string<br>      validation_domain = string<br>    }))<br>    tags = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_amazon_issued_acm_certificates_arns"></a> [amazon\_issued\_acm\_certificates\_arns](#output\_amazon\_issued\_acm\_certificates\_arns) | ARNs of the Amazon issued ACM certificates. |
| <a name="output_amazon_issued_acm_certificates_validation_records"></a> [amazon\_issued\_acm\_certificates\_validation\_records](#output\_amazon\_issued\_acm\_certificates\_validation\_records) | Validation Records of the Amazon issued ACM certificates. |
<!-- END_TF_DOCS -->
