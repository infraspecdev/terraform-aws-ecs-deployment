<!-- BEGIN_TF_DOCS -->
# asg

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
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Either to create an IAM Instance Profile to use with the Launch Template | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Either to create the IAM Role to associate with the IAM Instance Profile | `bool` | `true` | no |
| <a name="input_create_launch_template"></a> [create\_launch\_template](#input\_create\_launch\_template) | Either to create a Launch Template to associate with the Autoscaling group | `bool` | `true` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired capacity for the Autoscaling group | `number` | n/a | yes |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | Name of the IAM Instance Profile | `string` | `null` | no |
| <a name="input_iam_instance_profile_tags"></a> [iam\_instance\_profile\_tags](#input\_iam\_instance\_profile\_tags) | Resource Tags for the IAM Instance Profile | `map(any)` | `{}` | no |
| <a name="input_iam_role_ec2_container_service_role_arn"></a> [iam\_role\_ec2\_container\_service\_role\_arn](#input\_iam\_role\_ec2\_container\_service\_role\_arn) | ARN of the EC2 Container Service Role for EC2 | `string` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name for the IAM Role | `string` | `null` | no |
| <a name="input_iam_role_tags"></a> [iam\_role\_tags](#input\_iam\_role\_tags) | Resource Tags for IAM Role | `map(any)` | `{}` | no |
| <a name="input_instances_tags"></a> [instances\_tags](#input\_instances\_tags) | Resources Tags to propagate to the Instances | `map(any)` | `{}` | no |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | Launch Template to use with the Autoscaling group | <pre>object({<br>    name                   = optional(string, "")<br>    image_id               = optional(string, "")<br>    instance_type          = optional(string, "")<br>    vpc_security_group_ids = optional(list(string), [])<br>    key_name               = optional(string, "")<br>    user_data              = optional(string, "")<br>    tags                   = optional(map(any), {})<br>  })</pre> | n/a | yes |
| <a name="input_launch_template_id"></a> [launch\_template\_id](#input\_launch\_template\_id) | Identifier of the Launch Template | `string` | `null` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Max. size for the Autoscaling group | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Min. size for the Autoscaling group | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Autoscaling Group | `string` | n/a | yes |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | Whether to enable protection for Autoscaling group from scaling in instances | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resources Tags for Autoscaling group | `map(any)` | `{}` | no |
| <a name="input_vpc_zone_identifier"></a> [vpc\_zone\_identifier](#input\_vpc\_zone\_identifier) | Identifiers of the VPC Subnets | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Autoscaling group |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | ARN of the IAM Instance Profile |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | Identifier of the IAM Instance Profile |
| <a name="output_iam_role_id"></a> [iam\_role\_id](#output\_iam\_role\_id) | Identifier of the IAM Role |
| <a name="output_id"></a> [id](#output\_id) | Identifier of the Autoscaling group |
| <a name="output_launch_template_arn"></a> [launch\_template\_arn](#output\_launch\_template\_arn) | ARN of the Launch Template |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | Identifier of the Launch Template |
<!-- END_TF_DOCS -->
