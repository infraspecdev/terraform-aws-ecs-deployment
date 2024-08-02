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
  type        = any
}

################################################################################
# ECS Task Definition
################################################################################

variable "task_definition" {
  description = "ECS Task Definition to use for running tasks."
  type        = any
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
  type        = any
  default     = {}
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

variable "create_acm" {
  description = "Creates the ACM certificates to use with the Load Balancer."
  type        = bool
  default     = false
}

variable "acm_amazon_issued_certificates" {
  description = "Amazon-issued ACM certificates to create."
  type        = any
  default     = {}
}

variable "acm_imported_certificates" {
  description = "Imported ACM certificates to create."
  type        = any
  default     = {}
}
