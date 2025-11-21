<!-- BEGIN_TF_DOCS -->
# acm

This sub-module creates the Amazon-issued certificate for a given domain with `validation_option` configuration.

## Presets

### ACM Certificate

- The `validation_method` is set to `DNS` as the recommended method, and can be overridden to use `EMAIL` method if required.
- The `validation_method` is not marked as nullable, and is a required attribute for Amazon-issued ACM certificates.
- The `key_algorithm` is set to `RSA_2048` as the default algorithm, and can be overridden to specify a different algorithm if required.

### Route53 Record

- The `allow_override` is set to `true` as the default option, and can be overridden to `false` if required.

## Notes

- ACM certificate is created before destroying the existing one (to update the configuration), which is the recommended practice.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_aws.cross_account_provider"></a> [aws.cross\_account\_provider](#provider\_aws.cross\_account\_provider) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.cross_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_domain_name"></a> [certificate\_domain\_name](#input\_certificate\_domain\_name) | (Required) Domain name for which the certificate should be issued. | `string` | n/a | yes |
| <a name="input_certificate_key_algorithm"></a> [certificate\_key\_algorithm](#input\_certificate\_key\_algorithm) | (Optional) Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data. | `string` | `"RSA_2048"` | no |
| <a name="input_certificate_subject_alternative_names"></a> [certificate\_subject\_alternative\_names](#input\_certificate\_subject\_alternative\_names) | (Optional) Set of domains that should be SANs in the issued certificate. | `list(string)` | `[]` | no |
| <a name="input_certificate_validation_method"></a> [certificate\_validation\_method](#input\_certificate\_validation\_method) | (Optional) Which method to use for validation. DNS or EMAIL are valid. | `string` | `"DNS"` | no |
| <a name="input_certificate_validation_option"></a> [certificate\_validation\_option](#input\_certificate\_validation\_option) | (Optional) Configuration block used to specify information about the initial validation of each domain name. | <pre>object({<br/>    domain_name       = string<br/>    validation_domain = string<br/>  })</pre> | `null` | no |
| <a name="input_record_allow_overwrite"></a> [record\_allow\_overwrite](#input\_record\_allow\_overwrite) | (Optional) Allow creation of this record in Terraform to overwrite an existing record, if any. | `bool` | `true` | no |
| <a name="input_record_zone_id"></a> [record\_zone\_id](#input\_record\_zone\_id) | (Required) Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone. | `string` | n/a | yes |
| <a name="input_route53_assume_role_arn"></a> [route53\_assume\_role\_arn](#input\_route53\_assume\_role\_arn) | (Optional) IAM role ARN to assume for Route53 operations | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | ARN of the ACM certificate. |
| <a name="output_acm_certificate_id"></a> [acm\_certificate\_id](#output\_acm\_certificate\_id) | ARN of the ACM certificate. |
| <a name="output_acm_certificate_validation_id"></a> [acm\_certificate\_validation\_id](#output\_acm\_certificate\_validation\_id) | Identifier of the ACM certificate validation resource. |
| <a name="output_route53_record_id"></a> [route53\_record\_id](#output\_route53\_record\_id) | Identifier of the Route53 Record (supports same & cross-account). |
<!-- END_TF_DOCS -->
