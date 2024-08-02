variable "cluster_name" {
  description = "(Required) Name of the cluster."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

################################################################################
# ECS Service
################################################################################

variable "service" {
  description = "Configuration for ECS Service."
  type = object({
    name                               = string
    deployment_maximum_percent         = optional(number)
    deployment_minimum_healthy_percent = optional(number)
    desired_count                      = optional(number)
    enable_ecs_managed_tags            = optional(bool, true)
    enable_execute_command             = optional(bool)
    force_new_deployment               = optional(bool, true)
    health_check_grace_period_seconds  = optional(number)
    iam_role                           = optional(string)
    propagate_tags                     = optional(string)
    scheduling_strategy                = optional(string)
    triggers                           = optional(map(string))
    wait_for_steady_state              = optional(bool)
    load_balancer                      = optional(any)
    network_configuration              = optional(any)
    service_connect_configuration      = optional(any)
    volume_configuration               = optional(any)
    deployment_circuit_breaker         = optional(any)
    service_registries                 = optional(any)
    tags                               = optional(map(string), {})
  })
}

################################################################################
# ECS Task Definition
################################################################################

variable "task_definition" {
  description = "ECS Task Definition to use for running tasks."
  type = object({
    container_definitions = any
    family                = string
    cpu                   = optional(string)
    execution_role_arn    = optional(string)
    ipc_mode              = optional(string)
    memory                = optional(string)
    network_mode          = optional(string, "awsvpc")
    pid_mode              = optional(string)
    skip_destroy          = optional(bool)
    task_role_arn         = optional(string)
    track_latest          = optional(bool)
    runtime_platform      = optional(any)
    volume                = optional(any)
    tags                  = optional(map(string), {})
  })
}

################################################################################
# Capacity Provider Sub-module
################################################################################

variable "create_capacity_provider" {
  description = "Creates a new Capacity Provider to use with the Autoscaling Group."
  type        = bool
  default     = true
}

variable "capacity_provider_default_auto_scaling_group_arn" {
  description = "ARN for this Auto Scaling Group."
  type        = string
  default     = null
}

variable "capacity_providers" {
  description = "Capacity Providers to associate with the ECS Cluster."
  type        = any
  default     = {}
}

variable "default_capacity_providers_strategies" {
  description = "(Optional) Set of capacity provider strategies to use by default for the cluster."
  type        = any
  default     = []
}

################################################################################
# Application Load Balancer Sub-module
################################################################################

variable "create_alb" {
  description = "Creates a new Application Load Balancer to use with the ECS Service."
  type        = bool
  default     = true
}

variable "load_balancer" {
  description = "Configuration for the Application Load Balancer."
  type = object({
    name                       = optional(string)
    internal                   = optional(bool, false)
    subnets_ids                = optional(list(string), [])
    security_groups_ids        = optional(list(string), [])
    preserve_host_header       = optional(bool)
    enable_deletion_protection = optional(bool, false)
    target_groups              = optional(any, {})
    listeners                  = optional(any, {})
    listener_rules             = optional(any, {})
    tags                       = optional(map(string), {})
  })
  default = {}
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

variable "create_acm" {
  description = "Creates the ACM certificates to use with the Load Balancer."
  type        = bool
  default     = false
}

variable "acm_certificates" {
  description = "ACM certificates to create."
  type = map(object({
    domain_name               = string
    subject_alternative_names = optional(list(string), [])
    validation_method         = optional(string)
    key_algorithm             = optional(string)
    validation_option = optional(object({
      domain_name       = string
      validation_domain = string
    }))
    tags                   = optional(map(string), {})
    record_zone_id         = string
    record_allow_overwrite = optional(bool)
  }))
  default = {}
}
