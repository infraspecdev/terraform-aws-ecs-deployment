################################################################################
# ECS Capacity Provider
################################################################################

output "ids" {
  description = "Auto Scaling Group ids."
  value       = [for ecs_capacity_provider in aws_ecs_capacity_provider.this : ecs_capacity_provider.id]
}

output "arns" {
  description = "ARNs for this Auto Scaling Group."
  value       = [for ecs_capacity_provider in aws_ecs_capacity_provider.this : ecs_capacity_provider.arn]
}

################################################################################
# ECS Cluster Capacity Providers
################################################################################

output "ecs_cluster_capacity_providers_id" {
  description = "Same as `cluster_name`"
  value       = aws_ecs_cluster_capacity_providers.this.id
}
