<!-- BEGIN_TF_DOCS -->
# acm

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
| [aws_acm_certificate.amazon_issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.imported](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.private_ca_issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_issued_certificates"></a> [amazon\_issued\_certificates](#input\_amazon\_issued\_certificates) | List of Amazon-issued certificates to ACM create | <pre>map(object({<br>    domain_name               = string<br>    subject_alternative_names = optional(list(string), [])<br>    validation_method         = optional(string, null)<br>    key_algorithm             = optional(string, null)<br>    options = optional(object({<br>      certificate_transparency_logging_preference = optional(string, null)<br>    }))<br>    validation_option = optional(object({<br>      domain_name       = string<br>      validation_domain = string<br>    }))<br>    tags = optional(map(any), {})<br>  }))</pre> | `{}` | no |
| <a name="input_imported_certificates"></a> [imported\_certificates](#input\_imported\_certificates) | List of imported certificates to use to create ACM certificates | <pre>map(object({<br>    private_key       = string<br>    certificate_body  = string<br>    certificate_chain = optional(string, null)<br>    tags              = optional(map(any), {})<br>  }))</pre> | `{}` | no |
| <a name="input_private_ca_issued_certificates"></a> [private\_ca\_issued\_certificates](#input\_private\_ca\_issued\_certificates) | List of Private CA issued certificates to use to create ACM certificates | <pre>map(object({<br>    certificate_authority_arn = string<br>    domain_name               = string<br>    early_renewal_duration    = optional(string, null)<br>    tags                      = optional(map(any), {})<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource Tags to use with the created ACM certificates | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_amazon_issued_acm_certificates_arns"></a> [amazon\_issued\_acm\_certificates\_arns](#output\_amazon\_issued\_acm\_certificates\_arns) | ARNs of the Amazon issued ACM certificates |
| <a name="output_amazon_issued_acm_certificates_validation_records"></a> [amazon\_issued\_acm\_certificates\_validation\_records](#output\_amazon\_issued\_acm\_certificates\_validation\_records) | Validation Records of the Amazon issued ACM certificates |
| <a name="output_imported_acm_certificates_arns"></a> [imported\_acm\_certificates\_arns](#output\_imported\_acm\_certificates\_arns) | ARNs of the Imported ACM certificates |
| <a name="output_private_ca_issued_acm_certificates_arns"></a> [private\_ca\_issued\_acm\_certificates\_arns](#output\_private\_ca\_issued\_acm\_certificates\_arns) | ARNs of the Private CA issued ACM certificates |
| <a name="output_private_ca_issued_acm_certificates_validation_records"></a> [private\_ca\_issued\_acm\_certificates\_validation\_records](#output\_private\_ca\_issued\_acm\_certificates\_validation\_records) | Validation Records of the Private CA issued ACM certificates |
<!-- END_TF_DOCS -->
