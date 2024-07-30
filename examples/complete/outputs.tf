################################################################################
# ECS Deployment
################################################################################

output "ecs_service_arn" {
  description = "ARN of the ECS Service"
  value       = module.ecs_deployment.ecs_service_arn
}

output "task_definition_arn" {
  description = "ARN of the ECS Task Definition"
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
# Application Load Balancer
################################################################################

output "alb_arn" {
  description = "ARN of the Application Load Balancer ECS Service"
  value       = module.ecs_deployment.alb_arn
}

output "target_group_id" {
  description = "Identifier of the Target Group instances"
  value       = module.ecs_deployment.alb_target_groups_ids["this"]
}

output "target_group_arn" {
  description = "ARN of the Target Group instances"
  value       = module.ecs_deployment.alb_target_groups_arns["this"]
}

output "listener_id" {
  description = "Identifier of the ALB Listener forwarding to container instances"
  value       = module.ecs_deployment.alb_listeners_ids["this"]
}

output "listener_arn" {
  description = "ARN of the ALB Listener forwarding to container instances"
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

output "alb_allow_all_sg_id" {
  description = "ID of the Security Group for Application Load Balancer to allow all traffic from any source"
  value       = aws_security_group.alb_allow_all.id
}
