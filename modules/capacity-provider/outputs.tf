################################################################################
# ECS Capacity Provider
################################################################################

output "ids" {
  description = "Identifiers for the ECS Capacity Providers"
  value       = [for i in aws_ecs_capacity_provider.this : aws_ecs_capacity_provider.this[i].id]
}

output "arns" {
  description = "ARNs for the ECS Capacity Providers"
  value       = [for i in aws_ecs_capacity_provider.this : aws_ecs_capacity_provider.this[i].arn]
}

################################################################################
# ECS Cluster Capacity Providers
################################################################################

output "ecs_cluster_capacity_providers_id" {
  description = "Identifier for the ECS Cluster Capacity Providers"
  value       = aws_ecs_cluster_capacity_providers.this.id
}
