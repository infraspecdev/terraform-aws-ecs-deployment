locals {
  acm_certificate_domain_validation_option = tolist(aws_acm_certificate.this.domain_validation_options)[0]
  acm_certificate_validation_record = {
    name  = local.acm_certificate_domain_validation_option.resource_record_name
    type  = local.acm_certificate_domain_validation_option.resource_record_type
    value = local.acm_certificate_domain_validation_option.resource_record_value
  }
}

################################################################################
# ACM Certificate
################################################################################

resource "aws_acm_certificate" "this" {
  domain_name               = var.certificate_domain_name
  subject_alternative_names = var.certificate_subject_alternative_names
  validation_method         = var.certificate_validation_method
  key_algorithm             = var.certificate_key_algorithm

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
  zone_id         = var.record_zone_id
  name            = local.acm_certificate_validation_record.name
  type            = local.acm_certificate_validation_record.type
  records         = [local.acm_certificate_validation_record.value]
  ttl             = 60
  allow_overwrite = var.record_allow_overwrite
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.this.fqdn]
}
