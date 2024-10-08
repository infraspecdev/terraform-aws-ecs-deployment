################################################################################
# Load Balancer
################################################################################

variable "name" {
  description = "(Optional) Name of the LB."
  type        = string
  default     = null
}

variable "internal" {
  description = "(Optional) If true, the LB will be internal."
  type        = bool
  nullable    = false
  default     = false
}

variable "security_groups_ids" {
  description = "(Optional) List of security group IDs to assign to the LB."
  type        = list(string)
  nullable    = false
  default     = []
}

variable "subnets_ids" {
  description = "(Optional) List of subnet IDs to attach to the LB."
  type        = list(string)
  nullable    = false
}

variable "preserve_host_header" {
  description = "(Optional) Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change."
  type        = bool
  nullable    = false
  default     = true
}

variable "enable_deletion_protection" {
  description = "(Optional) If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
  nullable    = false
  default     = false
}

variable "access_logs" {
  description = "(Optional) Access Logs block."
  type = object({
    bucket  = string
    enabled = optional(bool, true)
    prefix  = optional(string, null)
  })
  default = null
}

variable "connection_logs" {
  description = "(Optional) Connection Logs block."
  type = object({
    bucket  = string
    enabled = optional(bool, false)
    prefix  = optional(string, null)
  })
  default = null
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the resource."
  type        = map(string)
  nullable    = false
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
  nullable = false
  default  = {}
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
    certificate_arn = optional(string)
    port            = optional(number)
    protocol        = optional(string, "HTTP")
    ssl_policy      = optional(string, null)
    tags            = optional(map(string), {})
  }))
  nullable = false
  default  = {}
}

################################################################################
# Load Balancer Listener Rule
################################################################################

variable "listener_rules" {
  description = "Listener rules to associate with the the ALB Listeners."
  type = map(object({
    listener = string
    priority = optional(number)
    action = list(object({
      type = string
      authenticate_oidc = optional(object({
        authorization_endpoint     = string
        client_id                  = string
        client_secret              = string
        issuer                     = string
        on_unauthenticated_request = optional(string)
        scope                      = optional(string)
        session_cookie_name        = optional(string)
        token_endpoint             = string
        user_info_endpoint         = string
      }))
      target_group = optional(string)
    }))
    condition = set(object({
      host_header = optional(object({
        values = set(string)
      }))
      path_pattern = optional(object({
        values = set(string)
      }))
      http_request_method = optional(object({
        values = set(string)
      }))
    }))
    tags = optional(map(string), {})
  }))
  nullable = false
  default  = {}
}
