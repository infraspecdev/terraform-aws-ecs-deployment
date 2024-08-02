################################################################################
# ACM Certificate
################################################################################

variable "amazon_issued_certificates" {
  description = "List of Amazon-issued certificates to ACM create."
  type = map(object({
    domain_name               = string
    subject_alternative_names = optional(list(string), [])
    validation_method         = optional(string, null)
    key_algorithm             = optional(string, null)
    validation_option = optional(object({
      domain_name       = string
      validation_domain = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
