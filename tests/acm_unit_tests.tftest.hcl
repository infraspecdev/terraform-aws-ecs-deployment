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

run "imported_certificates_attributes_match" {
  command = plan

  module {
    source = "./modules/acm"
  }

  variables {
    imported_certificates = {
      example = {
        private_key       = "example_private_key"
        certificate_body  = "example_certificate_body"
        certificate_chain = "example_certificate_chain"

        tags = {
          Example = "Tag"
        }
      }
    }
  }

  assert {
    condition     = aws_acm_certificate.imported["example"].private_key == var.imported_certificates.example.private_key
    error_message = "Private key mismatch"
  }

  assert {
    condition     = aws_acm_certificate.imported["example"].certificate_body == var.imported_certificates.example.certificate_body
    error_message = "Certificate body mismatch"
  }

  assert {
    condition     = aws_acm_certificate.imported["example"].certificate_chain == var.imported_certificates.example.certificate_chain
    error_message = "Certificate chain mismatch"
  }

  assert {
    condition     = aws_acm_certificate.imported["example"].tags == var.imported_certificates.example.tags
    error_message = "Tags mismatch"
  }
}
