provider "aws" {
  region = "ap-south-1"
}

################################################################################
# ACM
################################################################################

run "acm_certificate_attributes_match" {
  command = plan

  module {
    source = "./modules/acm"
  }

  variables {
    certificate_domain_name               = "example.domain"
    certificate_subject_alternative_names = ["example_optional_name"]
    certificate_validation_method         = "EMAIL"
    certificate_key_algorithm             = "RSA_4096"

    certificate_validation_option = {
      domain_name       = "example.domain"
      validation_domain = "me@example.domain"
    }

    record_zone_id = "example_zone_id"

    tags = {
      Example = "Tag"
    }
  }

  assert {
    condition     = aws_acm_certificate.this.domain_name == var.certificate_domain_name
    error_message = "Domain name mismatch"
  }

  assert {
    condition     = aws_acm_certificate.this.validation_method == var.certificate_validation_method
    error_message = "Validation method mismatch"
  }

  assert {
    condition     = aws_acm_certificate.this.key_algorithm == var.certificate_key_algorithm
    error_message = "Key algorithm mismatch"
  }

  assert {
    condition     = tolist(aws_acm_certificate.this.validation_option)[0].domain_name == var.certificate_validation_option.domain_name
    error_message = "Validation option domain name mismatch"
  }

  assert {
    condition     = tolist(aws_acm_certificate.this.validation_option)[0].validation_domain == var.certificate_validation_option.validation_domain
    error_message = "Validation option validation domain mismatch"
  }

  assert {
    condition     = aws_acm_certificate.this.tags == var.tags
    error_message = "Tags mismatch"
  }
}
