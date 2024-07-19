################################################################################
# ECS Service
################################################################################

output "ecs_service_arn" {
  description = "ARN of the ECS Service"
  value       = aws_ecs_service.this.id
}

################################################################################
# ECS Task Definition
################################################################################

output "ecs_task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.this.arn
}

################################################################################
# Amazon Certificates Manager
################################################################################

output "amazon_issued_acm_certificates_arns" {
  description = "ARNs of the Amazon issued ACM certificates"
  value       = try(module.acm[0].amazon_issued_acm_certificates_arns, null)
}

output "amazon_issued_acm_certificates_validation_records" {
  description = "Validation Records of the Amazon issued ACM certificates"
  value       = try(module.acm[0].amazon_issued_acm_certificates_validation_records, null)
}

output "imported_acm_certificates_arns" {
  description = "ARNs of the Imported ACM certificates"
  value       = try(module.acm[0].imported_acm_certificates_arns, null)
}

output "private_ca_issued_acm_certificates_arns" {
  description = "ARNs of the Private CA issued ACM certificates"
  value       = try(module.acm[0].private_ca_issued_acm_certificates_arns, null)
}

output "private_ca_issued_acm_certificates_validation_records" {
  description = "Validation Records of the Private CA issued ACM certificates"
  value       = try(module.acm[0].private_ca_issued_acm_certificates_validation_records, null)
}

################################################################################
# Application Load Balancer
################################################################################

output "alb_id" {
  description = "Identifier of the Load Balancer"
  value       = try(module.alb[0].id, null)
}

output "alb_arn" {
  description = "ARN of the Load Balancer"
  value       = try(module.alb[0].arn, null)
}

output "alb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = try(module.alb[0].dns_name, null)
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Load Balancer (to be used in a Route 53 Alias record)"
  value       = try(module.alb[0].zone_id, null)
}

output "alb_target_groups_ids" {
  description = "Identifiers of the Target Groups"
  value       = try(module.alb[0].target_groups_ids, null)
}

output "alb_target_groups_arns" {
  description = "ARNs of the Target Groups"
  value       = try(module.alb[0].target_groups_arns, null)
}

output "alb_listeners_ids" {
  description = "Identifiers of the Listeners"
  value       = try(module.alb[0].listeners_ids, null)
}

output "alb_listeners_arns" {
  description = "ARNs of the Listeners"
  value       = try(module.alb[0].listeners_arns, null)
}

################################################################################
# Autoscaling Group
################################################################################

output "asg_id" {
  description = "Identifier of the Autoscaling group"
  value       = try(module.asg[0].id, null)
}

output "asg_arn" {
  description = "ARN of the Autoscaling group"
  value       = try(module.asg[0].arn, null)
}

output "asg_launch_template_id" {
  description = "Identifier of the Launch Template"
  value       = try(module.asg[0].launch_template_id, null)
}

output "asg_launch_template_arn" {
  description = "ARN of the Launch Template"
  value       = try(module.asg[0].launch_template_arn, null)
}

output "asg_iam_role_id" {
  description = "Identifier of the IAM Role"
  value       = try(module.asg[0].iam_role_id, null)
}

output "asg_iam_instance_profile_id" {
  description = "Identifier of the IAM Instance Profile"
  value       = try(module.asg[0].iam_instance_profile_id, null)
}

output "asg_iam_instance_profile_arn" {
  description = "ARN of the IAM Instance Profile"
  value       = try(module.asg[0].iam_instance_profile_arn, null)
}

################################################################################
# Capacity Provider
################################################################################

output "capacity_provider_ids" {
  description = "Identifiers for the ECS Capacity Providers"
  value       = try(module.capacity_provider[0].ids, null)
}

output "capacity_provider_arns" {
  description = "ARNs for the ECS Capacity Providers"
  value       = try(module.capacity_provider[0].arns, null)
}

output "capacity_provider_ecs_cluster_capacity_providers_id" {
  description = "Identifier for the ECS Cluster Capacity Providers"
  value       = try(module.capacity_provider[0].ecs_cluster_capacity_providers_id, null)
}
