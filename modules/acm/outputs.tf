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

output "route53_record_id" {
  description = "Identifier of the Route53 Record (supports same & cross-account)."
  value = (
    var.route53_assume_role_arn == null
    ? aws_route53_record.same_account[0].id
    : aws_route53_record.cross_account[0].id
  )
}


################################################################################
# ACM Certificate Validation
################################################################################

output "acm_certificate_validation_id" {
  description = "Identifier of the ACM certificate validation resource."
  value       = aws_acm_certificate_validation.this.id
}
