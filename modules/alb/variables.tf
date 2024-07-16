################################################################################
# Load Balancer
################################################################################

variable "name" {
  description = "Name of the ALB"
  type        = string
  default     = ""
}

variable "internal" {
  description = "Either the ALB is internal or internet-facing"
  type        = bool
  default     = false
}

variable "security_groups_ids" {
  description = "Identifiers of Security Groups for the ALB"
  type        = list(string)
  default     = []
}

variable "subnets_ids" {
  description = "Identifiers of the VPC Subnets where the ALB will be active"
  type        = list(string)
}

variable "preserve_host_header" {
  description = "Whether the ALB should preserve the Host Header in HTTP requests and send it to the target without any changes"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource Tags for the ALB"
  type        = map(any)
  default     = {}
}

################################################################################
# Load Balancer Target Groups
################################################################################

variable "target_groups" {
  description = "Target Groups to create and forward ALB ingress to"
  type = map(object({
    name         = optional(string)
    vpc_id       = optional(string)
    port         = optional(number)
    protocol     = optional(string)
    target_type  = optional(string)
    health_check = optional(any, {})
    tags         = optional(map(any), {})
  }))
  default = {}
}

################################################################################
# Load Balancer Listener
################################################################################

variable "listeners" {
  description = "Listeners to forward ALB ingress to desired Target Groups"
  type = list(object({
    default_action = list(object({
      type                 = string
      target_group         = string
      authenticate_cognito = optional(any, {})
      authenticate_oidc    = optional(any, {})
      fixed_response       = optional(any, {})
      forward              = optional(any, {})
      order                = optional(number)
      redirect             = optional(any, {})
    }))
    alpn_policy           = optional(string)
    certificate_arn       = optional(string)
    mutual_authentication = optional(any, {})
    port                  = optional(number)
    protocol              = optional(string)
    ssl_policy            = optional(string)
    tags                  = optional(map(any), {})
  }))
}
