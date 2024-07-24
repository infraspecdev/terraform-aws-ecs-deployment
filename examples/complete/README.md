<!-- BEGIN_TF_DOCS -->
# ECS Deployment Complete

Configuration in this directory creates:

- VPC with two private subnets and two public subnets
- Autoscaling Group with a Launch Template
- ECS Service in a pre-configured ECS Cluster to spin up a Nginx web server, and corresponding ECS Capacity Providers
- Internet-facing Application Load Balancer to access the internal Nginx server, and
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
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | n/a |
| <a name="module_ecs_deployment"></a> [ecs\_deployment](#module\_ecs\_deployment) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate_validation.base_domain_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.alb_allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_all_within_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_nginx_http_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.ecs_optimized_amzn_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_route53_zone.base_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_amazon_issued_certificate_arn"></a> [acm\_amazon\_issued\_certificate\_arn](#output\_acm\_amazon\_issued\_certificate\_arn) | ARN of the ACM Amazon-issued certificate for the base domain |
| <a name="output_alb_allow_all_sg_id"></a> [alb\_allow\_all\_sg\_id](#output\_alb\_allow\_all\_sg\_id) | ID of the Security Group for Application Load Balancer to allow all traffic from any source |
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the Application Load Balancer for Nginx ECS Service |
| <a name="output_allow_all_within_vpc_sg_id"></a> [allow\_all\_within\_vpc\_sg\_id](#output\_allow\_all\_within\_vpc\_sg\_id) | ID of the Security Group to allow all traffic from any source within the VPC |
| <a name="output_allow_nginx_http_from_alb_sg_id"></a> [allow\_nginx\_http\_from\_alb\_sg\_id](#output\_allow\_nginx\_http\_from\_alb\_sg\_id) | ID of the Security Group to allow all Nginx HTTP traffic from Application Load Balancer |
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | ARN of the Autoscaling group |
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | Identifier of the Autoscaling group |
| <a name="output_ecs_capacity_provider_arn"></a> [ecs\_capacity\_provider\_arn](#output\_ecs\_capacity\_provider\_arn) | ARN of the ECS Capacity Provider |
| <a name="output_ecs_capacity_provider_id"></a> [ecs\_capacity\_provider\_id](#output\_ecs\_capacity\_provider\_id) | Identifier of the ECS Capacity Provider |
| <a name="output_ecs_cluster_capacity_providers_id"></a> [ecs\_cluster\_capacity\_providers\_id](#output\_ecs\_cluster\_capacity\_providers\_id) | Identifier of the ECS Cluster Capacity Providers |
| <a name="output_ecs_service_arn"></a> [ecs\_service\_arn](#output\_ecs\_service\_arn) | ARN of the ECS Service for Nginx |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | ARN of the IAM Instance Profile |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | Identifier of the IAM Instance Profile |
| <a name="output_iam_instance_role_id"></a> [iam\_instance\_role\_id](#output\_iam\_instance\_role\_id) | Identifier of the IAM Instance Role |
| <a name="output_launch_template_arn"></a> [launch\_template\_arn](#output\_launch\_template\_arn) | ARN of the Launch Template |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | Identifier of the Launch Template |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | ARN of the ALB Listener forwarding to Nginx instances |
| <a name="output_listener_id"></a> [listener\_id](#output\_listener\_id) | Identifier of the ALB Listener forwarding to Nginx instances |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the Target Group for Nginx instances |
| <a name="output_target_group_id"></a> [target\_group\_id](#output\_target\_group\_id) | Identifier of the Target Group for Nginx instances |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the ECS Task Definition for Nginx |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Identifier of the VPC |
| <a name="output_vpc_private_subnets_arns"></a> [vpc\_private\_subnets\_arns](#output\_vpc\_private\_subnets\_arns) | ARNs of the Private Subnets in the VPC |
| <a name="output_vpc_private_subnets_ids"></a> [vpc\_private\_subnets\_ids](#output\_vpc\_private\_subnets\_ids) | Identifiers of the Private Subnets in the VPC |
| <a name="output_vpc_public_subnets_arns"></a> [vpc\_public\_subnets\_arns](#output\_vpc\_public\_subnets\_arns) | ARNs of the Public Subnets in the VPC |
| <a name="output_vpc_public_subnets_ids"></a> [vpc\_public\_subnets\_ids](#output\_vpc\_public\_subnets\_ids) | Identifiers of the Public Subnets in the VPC |
<!-- END_TF_DOCS -->
