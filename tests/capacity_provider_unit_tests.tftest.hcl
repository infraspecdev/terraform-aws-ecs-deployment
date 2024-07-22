provider "aws" {
  region = "ap-south-1"
}

################################################################################
# Capacity Provider
################################################################################

run "ecs_capacity_provider_attributes_match" {
  command = plan

  module {
    source = "./modules/capacity-provider"
  }

  variables {
    ecs_cluster_name               = "example-name"
    default_auto_scaling_group_arn = "arn:aws:autoscaling:us-west-2:123456789012:autoScalingGroup:my-asg-group:12345678-1234-1234-1234-123456789012"

    capacity_providers = {
      example = {
        name = "example-name"
        managed_scaling = {
          instance_warmup_period    = 100
          status                    = "ENABLED"
          target_capacity           = 100
          minimum_scaling_step_size = 1
          maximum_scaling_step_size = 1
        }

        tags = {
          Example = "Tag"
        }
      }
    }
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].name == var.capacity_providers["example"].name
    error_message = "Name mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].auto_scaling_group_arn == var.default_auto_scaling_group_arn
    error_message = "Autoscaling group ARN mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].managed_scaling[0].instance_warmup_period == var.capacity_providers["example"].managed_scaling.instance_warmup_period
    error_message = "Instance warmup period mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].managed_scaling[0].status == var.capacity_providers["example"].managed_scaling.status
    error_message = "Managed scaling status mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].managed_scaling[0].target_capacity == var.capacity_providers["example"].managed_scaling.target_capacity
    error_message = "Managed scaling target capacity mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].managed_scaling[0].minimum_scaling_step_size == var.capacity_providers["example"].managed_scaling.minimum_scaling_step_size
    error_message = "Managed scaling minimum scaling step size mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].managed_scaling[0].maximum_scaling_step_size == var.capacity_providers["example"].managed_scaling.maximum_scaling_step_size
    error_message = "Managed scaling maximum scaling step size mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].auto_scaling_group_provider[0].managed_termination_protection == "ENABLED"
    error_message = "Managed termination protection mismatch"
  }

  assert {
    condition     = aws_ecs_capacity_provider.this["example"].tags == var.capacity_providers["example"].tags
    error_message = "Tags mismatch"
  }
}

################################################################################
# ECS Cluster Capacity Providers
################################################################################

run "ecs_cluster_capacity_providers_attributes_match" {
  command = plan

  module {
    source = "./modules/capacity-provider"
  }

  variables {
    ecs_cluster_name               = "example-name"
    default_auto_scaling_group_arn = "arn:aws:autoscaling:us-west-2:123456789012:autoScalingGroup:my-asg-group:12345678-1234-1234-1234-123456789012"

    capacity_providers = {
      example = {
        name = "example-name"
        managed_scaling = {
          instance_warmup_period    = 100
          status                    = "ENABLED"
          target_capacity           = 100
          minimum_scaling_step_size = 1
          maximum_scaling_step_size = 1
        }

        tags = {
          Example = "Tag"
        }
      }
    }
    default_capacity_provider_strategies = [
      {
        capacity_provider = "example"
        base              = 0
        weight            = 1
      }
    ]
  }

  assert {
    condition     = aws_ecs_cluster_capacity_providers.this.cluster_name == var.ecs_cluster_name
    error_message = "ECS Cluster name mismatch"
  }

  assert {
    condition     = aws_ecs_cluster_capacity_providers.this.capacity_providers == toset([for _, v in var.capacity_providers : v.name])
    error_message = "Capacity providers mismatch"
  }

  assert {
    condition     = tolist(aws_ecs_cluster_capacity_providers.this.default_capacity_provider_strategy)[0].capacity_provider == var.capacity_providers["example"].name
    error_message = "Default capacity provider strategy's capacity provider mismatch"
  }

  assert {
    condition     = tolist(aws_ecs_cluster_capacity_providers.this.default_capacity_provider_strategy)[0].base == var.default_capacity_provider_strategies[0].base
    error_message = "Default capacity provider strategy's base mismatch"
  }

  assert {
    condition     = tolist(aws_ecs_cluster_capacity_providers.this.default_capacity_provider_strategy)[0].weight == var.default_capacity_provider_strategies[0].weight
    error_message = "Default capacity provider strategy's weight mismatch"
  }
}
