resource "aws_ecs_capacity_provider" "this" {
  for_each = var.capacity_providers

  name = each.value.name

  auto_scaling_group_provider {
    auto_scaling_group_arn = coalesce(each.value.auto_scaling_group_arn, var.default_auto_scaling_group_arn)

    dynamic "managed_scaling" {
      for_each = each.value.managed_scaling ? [1] : []

      content {
        instance_warmup_period    = each.value.managed_scaling.instance_warmup_period
        status                    = each.value.managed_scaling.status
        target_capacity           = each.value.managed_scaling.target_capacity
        minimum_scaling_step_size = each.value.managed_scaling.minimum_scaling_step_size
        maximum_scaling_step_size = each.value.managed_scaling.maximum_scaling_step_size
      }
    }

    managed_termination_protection = true
  }

  tags = each.value.tags
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = var.ecs_cluster_name

  capacity_providers = [for i in var.capacity_providers : element(var.capacity_providers, i).name]

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategies

    content {
      capacity_provider = each.value.capacity_provider
      base              = each.value.base
      weight            = each.value.weight
    }
  }
}
