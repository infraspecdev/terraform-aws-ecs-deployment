<!-- BEGIN_TF_DOCS -->
# ECS Deployment Complete

Configuration in this directory creates:

- ECS Service in a pre-configured ECS Cluster and corresponding ECS Capacity Providers
- Internet-facing Application Load Balancer to access the deployed services, and
- ACM to generate an Amazon-issued certificate for a base domain, and then create a Route53 A-type record with an endpoint

## Usage

To run this example, you will need to execute the commands:

```bash
terraform init
terraform plan
terraform apply
```

Please note that this example may create resources that can incur monetary charges on your AWS bill. You can run `terraform destroy` when you no longer need the resources.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_deployment"></a> [ecs\_deployment](#module\_ecs\_deployment) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate_validation.base_domain_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.alb_allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_route53_zone.base_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the application load balancer | `string` | n/a | yes |
| <a name="input_asg_arn"></a> [asg\_arn](#input\_asg\_arn) | ARN of the Auto Scaling group | `string` | n/a | yes |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain name for ACM | `string` | n/a | yes |
| <a name="input_capacity_provider_managed_scaling"></a> [capacity\_provider\_managed\_scaling](#input\_capacity\_provider\_managed\_scaling) | Managed scaling configuration for the Capacity Provider | `any` | n/a | yes |
| <a name="input_capacity_provider_name"></a> [capacity\_provider\_name](#input\_capacity\_provider\_name) | Name of the Capacity Provider | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | CPU units to allocate to the container | `number` | n/a | yes |
| <a name="input_container_essential"></a> [container\_essential](#input\_container\_essential) | Essential flag for the container | `bool` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Image of the container | `string` | n/a | yes |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | Memory in MB to allocate to the container | `number` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port on which the container will listen | `number` | n/a | yes |
| <a name="input_container_port_mappings"></a> [container\_port\_mappings](#input\_container\_port\_mappings) | Port mappings for the container | `any` | n/a | yes |
| <a name="input_container_readonly_root_filesystem"></a> [container\_readonly\_root\_filesystem](#input\_container\_readonly\_root\_filesystem) | Whether the root filesystem is readonly for the container | `bool` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | DNS endpoint for the application | `string` | n/a | yes |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | Port for the ALB listener | `number` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet IDs | `list(string)` | n/a | yes |
| <a name="input_security_group_alb"></a> [security\_group\_alb](#input\_security\_group\_alb) | Name of the security group for ALB | `string` | n/a | yes |
| <a name="input_service_desired_count"></a> [service\_desired\_count](#input\_service\_desired\_count) | Desired count for the ECS Service | `number` | n/a | yes |
| <a name="input_service_network_configuration_security_groups"></a> [service\_network\_configuration\_security\_groups](#input\_service\_network\_configuration\_security\_groups) | Security Groups for the ECS Service's Network Configuration | `list(string)` | n/a | yes |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL policy for the ALB | `string` | n/a | yes |
| <a name="input_target_group_health_check"></a> [target\_group\_health\_check](#input\_target\_group\_health\_check) | Health check configuration for the target group | `any` | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the target group | `string` | n/a | yes |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | Protocol to use with the target group | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the resources will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_amazon_issued_certificate_arn"></a> [acm\_amazon\_issued\_certificate\_arn](#output\_acm\_amazon\_issued\_certificate\_arn) | ARN of the ACM Amazon-issued certificate for the base domain |
| <a name="output_alb_allow_all_sg_id"></a> [alb\_allow\_all\_sg\_id](#output\_alb\_allow\_all\_sg\_id) | ID of the Security Group for Application Load Balancer to allow all traffic from any source |
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the Application Load Balancer ECS Service |
| <a name="output_ecs_capacity_provider_arn"></a> [ecs\_capacity\_provider\_arn](#output\_ecs\_capacity\_provider\_arn) | ARN of the ECS Capacity Provider |
| <a name="output_ecs_capacity_provider_id"></a> [ecs\_capacity\_provider\_id](#output\_ecs\_capacity\_provider\_id) | Identifier of the ECS Capacity Provider |
| <a name="output_ecs_cluster_capacity_providers_id"></a> [ecs\_cluster\_capacity\_providers\_id](#output\_ecs\_cluster\_capacity\_providers\_id) | Identifier of the ECS Cluster Capacity Providers |
| <a name="output_ecs_service_arn"></a> [ecs\_service\_arn](#output\_ecs\_service\_arn) | ARN of the ECS Service |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | ARN of the ALB Listener forwarding to container instances |
| <a name="output_listener_id"></a> [listener\_id](#output\_listener\_id) | Identifier of the ALB Listener forwarding to container instances |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the Target Group instances |
| <a name="output_target_group_id"></a> [target\_group\_id](#output\_target\_group\_id) | Identifier of the Target Group instances |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the ECS Task Definition |
<!-- END_TF_DOCS -->
