################################################################################
# S3 Bucket
################################################################################

variable "bucket" {
  description = "(Optional, Forces new resource) Name of the bucket."
  type        = string
  default     = null
}

variable "bucket_force_destroy" {
  description = "(Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error."
  type        = bool
  nullable    = false
  default     = false
}

variable "bucket_object_lock_enabled" {
  description = "(Optional, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled."
  type        = bool
  nullable    = false
  default     = false
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the bucket."
  type        = map(string)
  nullable    = false
  default     = {}
}

################################################################################
# S3 Bucket Policy
################################################################################

variable "bucket_policies" {
  description = "(Optional) Map of bucket policies to attach to the S3 bucket."
  type = map(object({
    id      = optional(string, null)
    version = optional(string, null)
    statements = optional(list(object({
      actions   = optional(set(string), [])
      effect    = optional(string, "Allow")
      resources = optional(set(string), [])
      principals = optional(list(object({
        identifiers = set(string)
        type        = string
      })), [])
    })), [])
  }))
  nullable = false
  default  = {}
}
