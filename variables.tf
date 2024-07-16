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
