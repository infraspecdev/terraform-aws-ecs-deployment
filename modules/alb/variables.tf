################################################################################
# Load Balancer
################################################################################

variable "name" {
  description = "(Optional) Name of the LB."
  type        = string
  default     = ""
}

variable "internal" {
  description = "(Optional) If true, the LB will be internal."
  type        = bool
  default     = false
}

variable "security_groups_ids" {
  description = "(Optional) List of security group IDs to assign to the LB."
  type        = list(string)
  default     = []
}

variable "subnets_ids" {
  description = "(Optional) List of subnet IDs to attach to the LB."
  type        = list(string)
}

variable "preserve_host_header" {
  description = "(Optional) Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "(Optional) If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

################################################################################
# Load Balancer Target Groups
################################################################################

variable "target_groups" {
  description = "Target Groups to create and forward ALB ingress to."
  type = map(object({
    name         = optional(string)
    vpc_id       = optional(string)
    port         = optional(number)
    protocol     = optional(string)
    target_type  = optional(string)
    health_check = optional(any, null)
    tags         = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# Load Balancer Listener
################################################################################

variable "listeners" {
  description = "Listeners to forward ALB ingress to desired Target Groups."
  type = map(object({
    default_action = list(object({
      type           = string
      target_group   = string
      fixed_response = optional(any, null)
      forward        = optional(any, null)
      order          = optional(number)
      redirect       = optional(any, null)
    }))
    alpn_policy     = optional(string)
    certificate_arn = optional(string)
    port            = optional(number)
    protocol        = optional(string)
    ssl_policy      = optional(string)
    tags            = optional(map(string), {})
  }))
}
