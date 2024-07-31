################################################################################
# ACM Amazon issued certificates
################################################################################

resource "aws_acm_certificate" "amazon_issued" {
  for_each = var.amazon_issued_certificates

  domain_name               = try(each.value.domain_name, null)
  subject_alternative_names = try(each.value.subject_alternative_names, null)
  validation_method         = try(each.value.validation_method, null)
  key_algorithm             = try(each.value.key_algorithm, null)

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

  private_key       = try(each.value.private_key, null)
  certificate_body  = try(each.value.certificate_body, null)
  certificate_chain = try(each.value.certificate_chain, null)

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, each.value.tags)
}
