<!-- BEGIN_TF_DOCS -->
# s3-bucket

This sub-module creates an S3 bucket with optional S3 bucket policies to attach.

## Presets

### S3 Bucket

- The `force_destroy` is set to `false` as the default option (which prevents the deletion of the S3 bucket if it has objects in it), and can be overridden to be `true`.

### S3 Bucket Policy

- The `effect` under `statement` in the `aws_iam_policy_document.this` data source is set to `Allow` as the default option (which grants the principal the defined permissions), and can be overridden to be `Deny`.

## Notes

- The S3 bucket policies are attached only if at least one policy is specified. Otherwise, no bucket policies are attached.

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
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | (Optional, Forces new resource) Name of the bucket. | `string` | `null` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | (Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_bucket_object_lock_enabled"></a> [bucket\_object\_lock\_enabled](#input\_bucket\_object\_lock\_enabled) | (Optional, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled. | `bool` | `false` | no |
| <a name="input_bucket_policies"></a> [bucket\_policies](#input\_bucket\_policies) | (Optional) Map of bucket policies to attach to the S3 bucket. | <pre>map(object({<br>    id      = optional(string, null)<br>    version = optional(string, null)<br>    statements = optional(list(object({<br>      actions   = optional(set(string), [])<br>      effect    = optional(string, "Allow")<br>      resources = optional(set(string), [])<br>      principals = optional(list(object({<br>        identifiers = set(string)<br>        type        = string<br>      })), [])<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Name of the bucket. |
<!-- END_TF_DOCS -->
