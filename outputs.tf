################################################################################
# ECS Service
################################################################################

output "ecs_service_arn" {
  description = "ARN that identifies the service."
  value       = aws_ecs_service.this.id
}

################################################################################
# ECS Task Definition
################################################################################

output "ecs_task_definition_arn" {
  description = "Full ARN of the Task Definition."
  value       = aws_ecs_task_definition.this.arn
}

################################################################################
# Amazon Certificates Manager
################################################################################

output "acm_certificates_ids" {
  description = "Identifiers of the ACM certificates."
  value       = try({ for k, v in module.acm : k => v.acm_certificate_id }, null)
}

output "acm_certificates_arns" {
  description = "ARNs of the ACM certificates."
  value       = try({ for k, v in module.acm : k => v.acm_certificate_arn }, null)
}

output "acm_route53_records_ids" {
  description = "Identifiers of the Route53 Records for validation of the ACM certificates."
  value       = try({ for k, v in module.acm : k => v.route53_record_id }, null)
}

output "acm_certificate_validation_id" {
  description = "Identifiers of the ACM certificates validation resources."
  value       = try({ for k, v in module.acm : k => v.acm_certificate_validation_id }, null)
}

################################################################################
# Application Load Balancer
################################################################################

output "alb_arn" {
  description = "ARN of the load balancer."
  value       = try(module.alb[0].arn, null)
}

output "alb_dns_name" {
  description = "DNS name of the load balancer."
  value       = try(module.alb[0].dns_name, null)
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Load Balancer."
  value       = try(module.alb[0].zone_id, null)
}

output "alb_target_groups_ids" {
  description = "Identifiers of the Target Groups."
  value       = try(module.alb[0].target_groups_ids, null)
}

output "alb_target_groups_arns" {
  description = "ARNs of the Target Groups."
  value       = try(module.alb[0].target_groups_arns, null)
}

output "alb_listeners_ids" {
  description = "Identifiers of the Listeners."
  value       = try(module.alb[0].listeners_ids, null)
}

output "alb_listeners_arns" {
  description = "ARNs of the Listeners."
  value       = try(module.alb[0].listeners_arns, null)
}

output "alb_listener_rules_ids" {
  description = "Identifiers of the Listener Rules."
  value       = try(module.alb[0].listener_rules_ids, null)
}

output "alb_listener_rules_arns" {
  description = "ARNs of the Listener Rules."
  value       = try(module.alb[0].listener_rules_arns, null)
}

################################################################################
# S3 Bucket
################################################################################

output "s3_bucket_id" {
  description = "Name of the bucket."
  value       = try(module.s3_bucket[0].bucket_id, null)
}

output "s3_bucket_arn" {
  description = "ARN of the bucket."
  value       = try(module.s3_bucket[0].bucket_arn, null)
}

################################################################################
# Capacity Provider
################################################################################

output "capacity_provider_ids" {
  description = "Identifiers for the ECS Capacity Providers."
  value       = try(module.capacity_provider[0].ids, null)
}

output "capacity_provider_arns" {
  description = "ARNs for the ECS Capacity Providers."
  value       = try(module.capacity_provider[0].arns, null)
}

output "capacity_provider_ecs_cluster_capacity_providers_id" {
  description = "Identifier for the ECS Cluster Capacity Providers."
  value       = try(module.capacity_provider[0].ecs_cluster_capacity_providers_id, null)
}
