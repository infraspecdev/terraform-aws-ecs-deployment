################################################################################
# ACM Certificate
################################################################################

resource "aws_acm_certificate" "this" {
  domain_name               = var.certificate_domain_name
  subject_alternative_names = try(var.certificate_subject_alternative_names, null)
  validation_method         = try(var.certificate_validation_method, null)
  key_algorithm             = try(var.certificate_key_algorithm, null)

  dynamic "validation_option" {
    for_each = try(var.certificate_validation_option, null) != null ? [1] : []

    content {
      domain_name       = var.certificate_validation_option.domain_name
      validation_domain = var.certificate_validation_option.validation_domain
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

################################################################################
# ACM Validation
################################################################################

resource "aws_route53_record" "this" {
  for_each = {
    for record in aws_acm_certificate.this.domain_validation_options : record.domain_name => {
      name  = record.resource_record_name
      type  = record.resource_record_type
      value = record.resource_record_value
    }
  }

  zone_id         = var.record_zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.value]
  ttl             = 60
  allow_overwrite = var.record_allow_overwrite
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for route53_record in aws_route53_record.this : route53_record.fqdn]
}
