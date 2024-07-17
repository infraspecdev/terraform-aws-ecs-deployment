################################################################################
# ACM Amazon issued certificates
################################################################################

resource "aws_acm_certificate" "amazon_issued" {
  for_each = var.amazon_issued_certificates

  domain_name               = each.value.domain_name
  subject_alternative_names = each.value.subject_alternative_names
  validation_method         = each.value.validation_method
  key_algorithm             = each.value.key_algorithm

  dynamic "options" {
    for_each = length(each.value.options != null ? each.value.options : {}) > 0 ? [1] : []

    content {
      certificate_transparency_logging_preference = each.value.options.certificate_transparency_logging_preference
    }
  }

  dynamic "validation_option" {
    for_each = length(each.value.validation_option != null ? each.value.validation_option : {}) > 0 ? [1] : []

    content {
      domain_name       = each.value.validation_option.domain_name
      validation_domain = each.value.validation_option.validation_domain
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, each.value.tags)
}

################################################################################
# ACM imported certificates
################################################################################

resource "aws_acm_certificate" "imported" {
  for_each = var.imported_certificates

  private_key       = each.value.private_key
  certificate_body  = each.value.certificate_body
  certificate_chain = each.value.certificate_chain

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, each.value.tags)
}

################################################################################
# ACM Private CA issued certificates
################################################################################

resource "aws_acm_certificate" "private_ca_issued" {
  for_each = var.private_ca_issued_certificates

  certificate_authority_arn = each.value.certificate_authority_arn
  domain_name               = each.value.domain_name
  early_renewal_duration    = each.value.early_renewal_duration

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, each.value.tags)
}
