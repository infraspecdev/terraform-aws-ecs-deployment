variable "vpc_id" {
  description = "VPC ID where the resources will be deployed"
  type        = string
}

variable "service_network_configuration_security_groups" {
  description = "Security Groups for the ECS Service's Network Configuration"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "asg_arn" {
  description = "ARN of the Auto Scaling group"
  type        = string
}

variable "capacity_provider_name" {
  description = "Name of the Capacity Provider"
  type        = string
}

variable "capacity_provider_managed_scaling" {
  description = "Managed scaling configuration for the Capacity Provider"
  type        = any
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "service_desired_count" {
  description = "Desired count for the ECS Service"
  type        = number
}

variable "container_image" {
  description = "Image of the container"
  type        = string
}

variable "container_port" {
  description = "Port on which the container will listen"
  type        = number
}

variable "container_cpu" {
  description = "CPU units to allocate to the container"
  type        = number
}

variable "container_memory" {
  description = "Memory in MB to allocate to the container"
  type        = number
}

variable "container_essential" {
  description = "Essential flag for the container"
  type        = bool
}

variable "container_port_mappings" {
  description = "Port mappings for the container"
  type        = any
}

variable "container_readonly_root_filesystem" {
  description = "Whether the root filesystem is readonly for the container"
  type        = bool
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_protocol" {
  description = "Protocol to use with the target group"
  type        = string
}

variable "target_group_health_check" {
  description = "Health check configuration for the target group"
  type        = any
}

variable "alb_name" {
  description = "Name of the application load balancer"
  type        = string
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "ssl_policy" {
  description = "SSL policy for the ALB"
  type        = string
}

variable "security_group_alb" {
  description = "Name of the security group for ALB"
  type        = string
}

variable "base_domain" {
  description = "Base domain name for ACM"
  type        = string
}

variable "endpoint" {
  description = "DNS endpoint for the application"
  type        = string
}
