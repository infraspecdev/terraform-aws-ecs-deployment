################################################################################
# ACM Certificate
################################################################################

variable "amazon_issued_certificates" {
  description = "List of Amazon-issued certificates to ACM create"
  type = map(object({
    domain_name               = string
    subject_alternative_names = optional(list(string), [])
    validation_method         = optional(string, null)
    key_algorithm             = optional(string, null)
    options = optional(object({
      certificate_transparency_logging_preference = optional(string, null)
    }))
    validation_option = optional(object({
      domain_name       = string
      validation_domain = string
    }))
    tags = optional(map(any), {})
  }))
  default = {}
}

variable "imported_certificates" {
  description = "List of imported certificates to use to create ACM certificates"
  type = map(object({
    private_key       = string
    certificate_body  = string
    certificate_chain = optional(string, null)
    tags              = optional(map(any), {})
  }))
  default = {}
}

variable "tags" {
  description = "Resource Tags to use with the created ACM certificates"
  type        = map(any)
  default     = {}
}
