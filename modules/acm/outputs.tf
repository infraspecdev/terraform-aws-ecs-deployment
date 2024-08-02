################################################################################
# ACM Certificate
################################################################################

output "acm_certificate_id" {
  description = "ARN of the ACM certificate."
  value       = aws_acm_certificate.this.id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate."
  value       = aws_acm_certificate.this.arn
}

################################################################################
# Route53 Record
################################################################################

output "route53_records_ids" {
  description = "Identifiers of the Validation Records of the ACM certificate."
  value       = [for record in aws_route53_record.this : record.id]
}

################################################################################
# ACM Certificate Validation
################################################################################

output "acm_certificate_validation_id" {
  description = "Identifier of the ACM certificate validation resource."
  value       = aws_acm_certificate_validation.this.id
}
