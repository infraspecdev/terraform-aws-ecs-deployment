################################################################################
# ACM Amazon issued certificates
################################################################################

output "amazon_issued_acm_certificates_arns" {
  description = "ARNs of the Amazon issued ACM certificates."
  value       = { for k, v in aws_acm_certificate.amazon_issued : k => v.arn }
}

output "amazon_issued_acm_certificates_validation_records" {
  description = "Validation Records of the Amazon issued ACM certificates."
  value = {
    for k, v in aws_acm_certificate.amazon_issued :
    k => [
      for record in v.domain_validation_options :
      {
        name   = record.resource_record_name
        type   = record.resource_record_type
        value  = record.resource_record_value
        domain = record.domain_name
      }
    ]
  }
}

################################################################################
# ACM imported certificates
################################################################################

output "imported_acm_certificates_arns" {
  description = "ARNs of the Imported ACM certificates."
  value       = { for k, v in aws_acm_certificate.imported : k => v.arn }
}
