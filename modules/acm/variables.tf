################################################################################
# ACM Certificate
################################################################################

variable "certificate_domain_name" {
  description = "(Required) Domain name for which the certificate should be issued."
  type        = string
}

variable "certificate_subject_alternative_names" {
  description = "(Optional) Set of domains that should be SANs in the issued certificate."
  type        = list(string)
  default     = []
}

variable "certificate_validation_method" {
  description = "(Optional) Which method to use for validation. DNS or EMAIL are valid."
  type        = string
  default     = "DNS"
}

variable "certificate_key_algorithm" {
  description = "(Optional) Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data."
  type        = string
  default     = null
}

variable "certificate_validation_option" {
  description = "(Optional) Configuration block used to specify information about the initial validation of each domain name."
  type = object({
    domain_name       = string
    validation_domain = string
  })
  default = null
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

################################################################################
# Route53 Record
################################################################################

variable "record_zone_id" {
  description = "(Required) Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone."
  type        = string
}

variable "record_allow_overwrite" {
  description = "(Optional) Allow creation of this record in Terraform to overwrite an existing record, if any."
  type        = bool
  default     = true
}
