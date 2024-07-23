################################################################################
# ECS Deployment
################################################################################

output "ecs_service_arn" {
  description = "ARN of the ECS Service for Nginx"
  value       = module.ecs_deployment.ecs_service_arn
}

output "task_definition_arn" {
  description = "ARN of the ECS Task Definition for Nginx"
  value       = module.ecs_deployment.ecs_task_definition_arn
}

################################################################################
# ECS Capacity Provider
################################################################################

output "ecs_capacity_provider_id" {
  description = "Identifier of the ECS Capacity Provider"
  value       = module.ecs_deployment.capacity_provider_ids[0]
}

output "ecs_capacity_provider_arn" {
  description = "ARN of the ECS Capacity Provider"
  value       = module.ecs_deployment.capacity_provider_arns[0]
}

output "ecs_cluster_capacity_providers_id" {
  description = "Identifier of the ECS Cluster Capacity Providers"
  value       = module.ecs_deployment.capacity_provider_ecs_cluster_capacity_providers_id
}

################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "Identifier of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets_ids" {
  description = "Identifiers of the Private Subnets in the VPC"
  value       = module.vpc.private_subnets
}

output "vpc_private_subnets_arns" {
  description = "ARNs of the Private Subnets in the VPC"
  value       = module.vpc.private_subnet_arns
}

output "vpc_public_subnets_ids" {
  description = "Identifiers of the Public Subnets in the VPC"
  value       = module.vpc.public_subnets
}

output "vpc_public_subnets_arns" {
  description = "ARNs of the Public Subnets in the VPC"
  value       = module.vpc.public_subnet_arns
}

################################################################################
# Autoscaling Group
################################################################################

output "asg_id" {
  description = "Identifier of the Autoscaling group"
  value       = module.asg.autoscaling_group_id
}

output "asg_arn" {
  description = "ARN of the Autoscaling group"
  value       = module.asg.autoscaling_group_arn
}

output "launch_template_id" {
  description = "Identifier of the Launch Template"
  value       = module.asg.launch_template_id
}

output "launch_template_arn" {
  description = "ARN of the Launch Template"
  value       = module.asg.launch_template_arn
}

################################################################################
# IAM
################################################################################

output "iam_instance_role_id" {
  description = "Identifier of the IAM Instance Role"
  value       = module.asg.iam_role_unique_id
}

output "iam_instance_profile_id" {
  description = "Identifier of the IAM Instance Profile"
  value       = module.asg.iam_instance_profile_id
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM Instance Profile"
  value       = module.asg.iam_instance_profile_arn
}

################################################################################
# Application Load Balancer
################################################################################

output "alb_arn" {
  description = "ARN of the Application Load Balancer for Nginx ECS Service"
  value       = module.ecs_deployment.alb_arn
}

output "target_group_id" {
  description = "Identifier of the Target Group for Nginx instances"
  value       = module.ecs_deployment.alb_target_groups_ids["this"]
}

output "target_group_arn" {
  description = "ARN of the Target Group for Nginx instances"
  value       = module.ecs_deployment.alb_target_groups_arns["this"]
}

output "listener_id" {
  description = "Identifier of the ALB Listener forwarding to Nginx instances"
  value       = module.ecs_deployment.alb_listeners_ids["this"]
}

output "listener_arn" {
  description = "ARN of the ALB Listener forwarding to Nginx instances"
  value       = module.ecs_deployment.alb_listeners_arns["this"]
}

################################################################################
# ACM
################################################################################

output "acm_amazon_issued_certificate_arn" {
  description = "ARN of the ACM Amazon-issued certificate for the base domain"
  value       = module.ecs_deployment.amazon_issued_acm_certificates_arns["base_domain"]
}

################################################################################
# Security Groups
################################################################################

output "allow_all_within_vpc_sg_id" {
  description = "ID of the Security Group to allow all traffic from any source within the VPC"
  value       = aws_security_group.allow_all_within_vpc.id
}

output "alb_allow_all_sg_id" {
  description = "ID of the Security Group for Application Load Balancer to allow all traffic from any source"
  value       = aws_security_group.alb_allow_all.id
}

output "allow_nginx_http_from_alb_sg_id" {
  description = "ID of the Security Group to allow all Nginx HTTP traffic from Application Load Balancer"
  value       = aws_security_group.allow_nginx_http_from_alb.id
}
