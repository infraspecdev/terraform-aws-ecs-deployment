################################################################################
# ECS Capacity Provider
################################################################################

output "ids" {
  description = "Identifiers for the ECS Capacity Providers"
  value       = [for ecs_capacity_provider in aws_ecs_capacity_provider.this : ecs_capacity_provider.id]
}

output "arns" {
  description = "ARNs for the ECS Capacity Providers"
  value       = [for ecs_capacity_provider in aws_ecs_capacity_provider.this : ecs_capacity_provider.arn]
}

################################################################################
# ECS Cluster Capacity Providers
################################################################################

output "ecs_cluster_capacity_providers_id" {
  description = "Identifier for the ECS Cluster Capacity Providers"
  value       = aws_ecs_cluster_capacity_providers.this.id
}
