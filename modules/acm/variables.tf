################################################################################
# ACM Certificate
################################################################################

variable "amazon_issued_certificates" {
  description = "List of Amazon-issued certificates to ACM create"
  type = map(object({
    domain_name               = string
    subject_alternative_names = optional(list(string), [])
    validation_method         = optional(string)
    key_algorithm             = optional(string)
    options = optional(object({
      certificate_transparency_logging_preference = optional(string)
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
    certificate_chain = optional(string)
    tags              = optional(map(any), {})
  }))
  default = {}
}

variable "private_ca_issued_certificates" {
  description = "List of Private CA issued certificates to use to create ACM certificates"
  type = map(object({
    certificate_authority_arn = string
    domain_name               = string
    early_renewal_duration    = optional(string)
    tags                      = optional(map(any), {})
  }))
  default = {}
}

variable "tags" {
  description = "Resource Tags to use with the created ACM certificates"
  type        = map(any)
  default     = {}
}
