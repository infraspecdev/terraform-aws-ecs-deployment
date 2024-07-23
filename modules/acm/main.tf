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
    for_each = try(each.value.options, null) != null ? [1] : []

    content {
      certificate_transparency_logging_preference = each.value.options.certificate_transparency_logging_preference
    }
  }

  dynamic "validation_option" {
    for_each = try(each.value.validation_option, null) != null ? [1] : []

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
