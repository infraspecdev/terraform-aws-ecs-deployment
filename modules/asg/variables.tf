variable "name" {
  description = "Name of the Autoscaling Group"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "Identifiers of the VPC Subnets"
  type        = list(string)

  validation {
    condition     = alltrue([for subnet_id in var.vpc_zone_identifier : startswith(subnet_id, "subnet-")])
    error_message = "Specified subnet ids must be valid subnet identifiers starting with \"subnet-\"."
  }
}

variable "protect_from_scale_in" {
  description = "Whether to enable protection for Autoscaling group from scaling in instances"
  type        = bool
  default     = false
}

variable "desired_capacity" {
  description = "Desired capacity for the Autoscaling group"
  type        = number

  validation {
    condition     = var.desired_capacity >= 0
    error_message = "Specified desired capacity must be a valid non-negative number."
  }
}

variable "min_size" {
  description = "Min. size for the Autoscaling group"
  type        = number

  validation {
    condition     = var.min_size >= 0
    error_message = "Specified min. size must be a valid non-negative number."
  }
}

variable "max_size" {
  description = "Max. size for the Autoscaling group"
  type        = number

  validation {
    condition     = var.max_size >= 0
    error_message = "Specified max. size must be a valid non-negative number."
  }
}

variable "instances_tags" {
  description = "Resources Tags to propagate to the Instances"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Resources Tags for Autoscaling group"
  type        = map(any)
  default     = {}
}

################################################################################
# Launch Template
################################################################################

variable "launch_template" {
  description = "Launch Template to use with the Autoscaling group"
  type = object({
    name                   = optional(string, "")
    image_id               = optional(string, "")
    instance_type          = optional(string, "")
    vpc_security_group_ids = optional(list(string), [])
    key_name               = optional(string, "")
    user_data              = optional(string, "")
    tags                   = optional(map(any), {})
  })
  default = {}
}

variable "create_launch_template" {
  description = "Either to create a Launch Template to associate with the Autoscaling group"
  type        = bool
  default     = true
}

variable "launch_template_id" {
  description = "Identifier of the Launch Template"
  type        = string
  default     = null

  validation {
    condition     = var.launch_template_id == null || startswith(var.launch_template_id != null ? var.launch_template_id : "", "lt-")
    error_message = "Specified launch template id must be valid launch template identifier starting with \"lt-\"."
  }
}

################################################################################
# IAM Role
################################################################################

variable "create_iam_role" {
  description = "Either to create the IAM Role to associate with the IAM Instance Profile"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "Name for the IAM Role"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "Resource Tags for IAM Role"
  type        = map(any)
  default     = {}
}

variable "iam_role_ec2_container_service_role_arn" {
  description = "ARN of the EC2 Container Service Role for EC2"
  type        = string
}

################################################################################
# IAM Instance Profile
################################################################################

variable "create_iam_instance_profile" {
  description = "Either to create an IAM Instance Profile to use with the Launch Template"
  type        = bool
  default     = true
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM Instance Profile"
  type        = string
  default     = null
}

variable "iam_instance_profile_tags" {
  description = "Resource Tags for the IAM Instance Profile"
  type        = map(any)
  default     = {}
}
