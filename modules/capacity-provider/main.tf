################################################################################
# ECS Capacity Provider
################################################################################

resource "aws_ecs_capacity_provider" "this" {
  for_each = var.capacity_providers

  name = each.value.name

  auto_scaling_group_provider {
    auto_scaling_group_arn = coalesce(each.value.auto_scaling_group_arn, var.default_auto_scaling_group_arn)

    dynamic "managed_scaling" {
      for_each = try(each.value.managed_scaling, null) != null ? [1] : []

      content {
        instance_warmup_period    = try(each.value.managed_scaling.instance_warmup_period, null)
        status                    = try(each.value.managed_scaling.status, null)
        target_capacity           = try(each.value.managed_scaling.target_capacity, null)
        minimum_scaling_step_size = try(each.value.managed_scaling.minimum_scaling_step_size, null)
        maximum_scaling_step_size = try(each.value.managed_scaling.maximum_scaling_step_size, null)
      }
    }

    managed_termination_protection = try(each.value.managed_termination_protection, null)
  }

  tags = try(each.value.tags, {})
}

################################################################################
# ECS Cluster Capacity Providers
################################################################################

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = var.ecs_cluster_name

  capacity_providers = [for k, capacity_provider in aws_ecs_capacity_provider.this : capacity_provider.name]

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategies
    iterator = default_capacity_provider_strategies

    content {
      capacity_provider = aws_ecs_capacity_provider.this[default_capacity_provider_strategies.value.capacity_provider].name
      base              = try(default_capacity_provider_strategies.value.base, null)
      weight            = try(default_capacity_provider_strategies.value.weight, null)
    }
  }
}
