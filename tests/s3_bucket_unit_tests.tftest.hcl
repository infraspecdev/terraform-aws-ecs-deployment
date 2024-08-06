provider "aws" {
  region = "ap-south-1"
}

################################################################################
# S3 Bucket
################################################################################

run "s3_bucket_attributes_match" {
  command = plan

  module {
    source = "./modules/s3-bucket"
  }

  variables {
    bucket                     = "example-bucket"
    bucket_force_destroy       = true
    bucket_object_lock_enabled = true

    tags = {
      Example = "Tag"
    }
  }

  assert {
    condition     = aws_s3_bucket.this.bucket == var.bucket
    error_message = "Bucket mismatch"
  }

  assert {
    condition     = aws_s3_bucket.this.force_destroy == var.bucket_force_destroy
    error_message = "Force destroy mismatch"
  }

  assert {
    condition     = aws_s3_bucket.this.object_lock_enabled == var.bucket_object_lock_enabled
    error_message = "Object lock status mismatch"
  }

  assert {
    condition     = aws_s3_bucket.this.tags == var.tags
    error_message = "Tags mismatch"
  }
}

################################################################################
# IAM Policy Document
################################################################################

run "does_not_create_iam_policy_document_check" {
  command = plan

  module {
    source = "./modules/s3-bucket"
  }

  variables {}

  assert {
    condition     = length(data.aws_iam_policy_document.this) == 0
    error_message = "IAM policy document data source was created"
  }
}

run "iam_policy_document_attributes_match" {
  command = plan

  module {
    source = "./modules/s3-bucket"
  }

  variables {
    bucket_policies = {
      example-policy = {
        id      = "example-id"
        version = "2012-10-17"

        statements = [
          {
            sid = "example-sid"
            actions = [
              "s3:PutObject"
            ]
            effect = "Allow"
            resources = [
              "example/*"
            ]

            principals = [
              {
                identifiers = ["delivery.logs.amazonaws.com"]
                type        = "Service"
              }
            ]
          }
        ]
      }
    }
  }

  assert {
    condition     = length(data.aws_iam_policy_document.this) == 1
    error_message = "IAM policy document data source was not created"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].policy_id == var.bucket_policies["example-policy"].id
    error_message = "Policy id mismatch"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].version == var.bucket_policies["example-policy"].version
    error_message = "Version mismatch"
  }

  assert {
    condition     = length(data.aws_iam_policy_document.this["example-policy"].statement) == 1
    error_message = "Statement count mismatch"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].statement[0].sid == var.bucket_policies["example-policy"].statements[0].sid
    error_message = "Statement sid mismatch"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].statement[0].actions == var.bucket_policies["example-policy"].statements[0].actions
    error_message = "Statement actions mismatch"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].statement[0].effect == var.bucket_policies["example-policy"].statements[0].effect
    error_message = "Statement effect mismatch"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].statement[0].resources == var.bucket_policies["example-policy"].statements[0].resources
    error_message = "Statement resources mismatch"
  }

  assert {
    condition     = data.aws_iam_policy_document.this["example-policy"].statement[0].principals == toset(var.bucket_policies["example-policy"].statements[0].principals)
    error_message = "Statement principals mismatch"
  }
}

################################################################################
# S3 Bucket Policy
################################################################################

run "does_not_create_s3_bucket_policy_check" {
  command = plan

  module {
    source = "./modules/s3-bucket"
  }

  variables {}

  assert {
    condition     = length(aws_s3_bucket_policy.this) == 0
    error_message = "S3 bucket policy was created"
  }
}

run "s3_bucket_policy_attributes_match" {
  command = plan

  module {
    source = "./modules/s3-bucket"
  }

  variables {
    bucket_policies = {
      example-policy = {
        id      = "example-id"
        version = "2012-10-17"

        statements = [
          {
            actions = [
              "s3:PutObject"
            ]
            effect = "Allow"
            resources = [
              "example/*"
            ]

            principals = [
              {
                identifiers = ["delivery.logs.amazonaws.com"]
                type        = "Service"
              }
            ]
          }
        ]
      }
    }
  }

  assert {
    condition     = length(aws_s3_bucket_policy.this) == 1
    error_message = "S3 bucket policy was not created"
  }

  assert {
    condition     = jsondecode(aws_s3_bucket_policy.this["example-policy"].policy) == jsondecode(data.aws_iam_policy_document.this["example-policy"].json)
    error_message = "Policy mismatch"
  }
}
