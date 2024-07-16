################################################################################
# ECS Service
################################################################################

output "ecs_service_arn" {
  description = "ARN of the ECS Service"
  value       = aws_ecs_service.this.id
}

################################################################################
# ECS Task Definition
################################################################################

output "ecs_task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.this.arn
}
