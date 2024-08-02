provider "aws" {
  region = "ap-south-1"
}

################################################################################
# ACM
################################################################################

run "amazon_issued_certificates_attributes_match" {
  command = plan

  module {
    source = "./modules/acm"
  }

  variables {
    amazon_issued_certificates = {
      example = {
        domain_name               = "example.domain"
        subject_alternative_names = ["example_optional_name"]
        validation_method         = "EMAIL"
        key_algorithm             = "RSA_4096"

        validation_option = {
          domain_name       = "example.domain"
          validation_domain = "me@example.domain"
        }

        tags = {
          Example = "Tag"
        }
      }
    }
  }

  assert {
    condition     = aws_acm_certificate.amazon_issued["example"].domain_name == var.amazon_issued_certificates.example.domain_name
    error_message = "Domain name mismatch"
  }

  assert {
    condition     = aws_acm_certificate.amazon_issued["example"].validation_method == var.amazon_issued_certificates.example.validation_method
    error_message = "Validation method mismatch"
  }

  assert {
    condition     = aws_acm_certificate.amazon_issued["example"].key_algorithm == var.amazon_issued_certificates.example.key_algorithm
    error_message = "Key algorithm mismatch"
  }

  assert {
    condition     = tolist(aws_acm_certificate.amazon_issued["example"].validation_option)[0].domain_name == var.amazon_issued_certificates.example.validation_option.domain_name
    error_message = "Validation option domain name mismatch"
  }

  assert {
    condition     = tolist(aws_acm_certificate.amazon_issued["example"].validation_option)[0].validation_domain == var.amazon_issued_certificates.example.validation_option.validation_domain
    error_message = "Validation option validation domain mismatch"
  }

  assert {
    condition     = aws_acm_certificate.amazon_issued["example"].tags == var.amazon_issued_certificates.example.tags
    error_message = "Tags mismatch"
  }
}
