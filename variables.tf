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
    load_balancer                      = optional(any, [])
    network_configuration              = optional(any, null)
    service_connect_configuration      = optional(any, null)
    volume_configuration               = optional(any, null)
    deployment_circuit_breaker         = optional(any, null)
    service_registries                 = optional(any, null)
    tags                               = optional(map(string), {})
  })
  nullable = false
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
    runtime_platform      = optional(any, null)
    volume                = optional(any, null)
    tags                  = optional(map(string), {})
  })
  nullable = false
}

################################################################################
# Capacity Provider Sub-module
################################################################################

variable "create_capacity_provider" {
  description = "Creates a new Capacity Provider to use with the Autoscaling Group."
  type        = bool
  nullable    = false
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
  nullable    = false
  default     = {}
}

variable "default_capacity_providers_strategies" {
  description = "(Optional) Set of capacity provider strategies to use by default for the cluster."
  type        = any
  nullable    = false
  default     = []
}

################################################################################
# Application Load Balancer Sub-module
################################################################################

variable "create_alb" {
  description = "Creates a new Application Load Balancer to use with the ECS Service."
  type        = bool
  nullable    = false
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
    access_logs                = optional(any, null)
    connection_logs            = optional(any, null)
    target_groups              = optional(any, {})
    listeners                  = optional(any, {})
    listener_rules             = optional(any, {})
    tags                       = optional(map(string), {})
  })
  nullable = false
  default  = {}
}

################################################################################
# S3 Bucket
################################################################################

variable "create_s3_bucket_for_alb_logging" {
  description = "(Optional) Creates S3 bucket for storing ALB Access and Connection Logs."
  type        = bool
  nullable    = false
  default     = true
}

variable "s3_bucket_name" {
  description = "(Optional, Forces new resource) Name of the bucket."
  type        = string
  default     = null
}

variable "s3_bucket_force_destroy" {
  description = "(Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error."
  type        = bool
  nullable    = false
  default     = false
}

variable "s3_bucket_policy_id_prefix" {
  description = "(Optional) - Prefix of the ID for the policy document."
  type        = string
  nullable    = false
  default     = "ecs-deployment-alb-"
}

variable "s3_elb_service_account_arn" {
  description = "(Optional, Default:null) ARN of the ELB Service Account."
  type        = string
  default     = null
}

variable "s3_bucket_tags" {
  description = "(Optional) Map of tags to assign to the bucket."
  type        = map(string)
  nullable    = false
  default     = {}
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

variable "create_acm" {
  description = "Creates the ACM certificates to use with the Load Balancer."
  type        = bool
  nullable    = false
  default     = false
}

variable "acm_certificates" {
  description = "ACM certificates to create."
  type = map(object({
    domain_name               = string
    subject_alternative_names = optional(list(string), [])
    validation_method         = optional(string, "DNS")
    key_algorithm             = optional(string, "RSA_2048")
    validation_option = optional(object({
      domain_name       = string
      validation_domain = string
    }))
    tags                   = optional(map(string), {})
    record_zone_id         = string
    record_allow_overwrite = optional(bool, true)
  }))
  nullable = false
  default  = {}
}
