variable "cluster_name" {
  description = "Name of the ECS Cluster to use with the ECS Service"
  type        = string
}

variable "vpc_id" {
  description = "Identifier of the VPC to use"
  type        = string
}

################################################################################
# ECS Task Definition
################################################################################

variable "task_definition" {
  description = "ECS Task Definition to use for running tasks"
  type        = any
}

################################################################################
# ECS Service
################################################################################

variable "service" {
  description = "Configuration for ECS Service"
  type        = any
}

################################################################################
# Autoscaling Group Sub-module
################################################################################

variable "create_autoscaling_group" {
  description = "Creates a new Autoscaling group to use with the ECS Service"
  type        = bool
  default     = true
}

variable "autoscaling_group" {
  description = "Configuration for Autoscaling Group"
  type        = any
  default     = {}
}

################################################################################
# Capacity Provider Sub-module
################################################################################

variable "create_capacity_provider" {
  description = "Creates a new Capacity Provider to use with the Autoscaling Group"
  type        = bool
  default     = true
}

variable "capacity_provider_default_auto_scaling_group_arn" {
  description = "Default Autoscaling Group to use with the Capacity Providers"
  type        = string
  default     = null
}

variable "capacity_providers" {
  description = "Capacity Providers to create for use within the ECS Cluster"
  type        = any
  default     = {}
}

variable "default_capacity_providers_strategies" {
  description = "Default Capacity Provider Strategies to use"
  type        = any
  default     = []
}

################################################################################
# Application Load Balancer Sub-module
################################################################################

variable "create_alb" {
  description = "Creates a new Application Load Balancer to use with the ECS Service"
  type        = bool
  default     = true
}

variable "load_balancer" {
  description = "Configuration for the Application Load Balancer"
  type        = any
  default     = {}
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

variable "create_acm" {
  description = "Creates the ACM certificates to use with the Load Balancer"
  type        = bool
  default     = false
}

variable "acm_amazon_issued_certificates" {
  description = "Amazon-issued ACM certificates to create"
  type        = any
  default     = {}
}

variable "acm_imported_certificates" {
  description = "Imported ACM certificates to create"
  type        = any
  default     = {}
}

variable "acm_private_ca_issued_certificates" {
  description = "Private CA Issued ACM certificates to create"
  type        = any
  default     = {}
}
