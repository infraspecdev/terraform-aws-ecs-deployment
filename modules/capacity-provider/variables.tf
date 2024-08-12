################################################################################
# ECS Capacity Provider
################################################################################

variable "capacity_providers" {
  description = "Capacity Providers to associate with the ECS Cluster."
  type = map(object({
    name                   = string
    auto_scaling_group_arn = optional(string)
    managed_scaling = optional(
      object({
        instance_warmup_period    = optional(number)
        status                    = optional(string)
        target_capacity           = optional(number)
        minimum_scaling_step_size = optional(number)
        maximum_scaling_step_size = optional(number)
      })
    )
    managed_termination_protection = optional(string, "DISABLED")
    tags                           = optional(map(string), {})
  }))
  nullable = false
  default  = {}
}

################################################################################
# ECS Cluster Capacity Providers
################################################################################

variable "ecs_cluster_name" {
  description = "(Required) Name of the cluster."
  type        = string
  nullable    = false
}

variable "default_capacity_provider_strategies" {
  description = "(Optional) Set of capacity provider strategies to use by default for the cluster."
  type = list(object({
    capacity_provider = string
    weight            = optional(number, 1)
    base              = optional(number, 0)
  }))
  nullable = false
  default  = []

  validation {
    condition     = alltrue([for e in var.default_capacity_provider_strategies : e.weight >= 0])
    error_message = "Specified weights for default capacity provider strategies must be a non-negative number."
  }

  validation {
    condition     = alltrue([for e in var.default_capacity_provider_strategies : e.base >= 0])
    error_message = "Specified bases for default capacity provider strategies must be a non-negative number."
  }
}

variable "default_auto_scaling_group_arn" {
  description = "ARN for this Auto Scaling Group."
  type        = string
  nullable    = false

  validation {
    condition     = startswith(var.default_auto_scaling_group_arn, "arn:")
    error_message = "Specified default autoscaling group ARN must be a valid ARN starting with \"arn:\"."
  }
}
