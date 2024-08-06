locals {
  # S3 Bucket Policy
  create_s3_bucket_policy = length(var.bucket_policies) > 0
}

################################################################################
# S3 Bucket
################################################################################

resource "aws_s3_bucket" "this" {
  bucket              = var.bucket
  force_destroy       = var.bucket_force_destroy
  object_lock_enabled = var.bucket_object_lock_enabled

  tags = var.tags
}

################################################################################
# S3 Bucket Policy
################################################################################

data "aws_iam_policy_document" "this" {
  for_each = local.create_s3_bucket_policy ? var.bucket_policies : {}

  policy_id = each.value.id
  version   = each.value.version

  dynamic "statement" {
    for_each = each.value.statements

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      effect    = statement.value.effect
      resources = statement.value.resources

      dynamic "principals" {
        for_each = statement.value.principals
        iterator = principal

        content {
          identifiers = principal.value.identifiers
          type        = principal.value.type
        }
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  for_each = local.create_s3_bucket_policy ? data.aws_iam_policy_document.this : {}

  bucket = aws_s3_bucket.this.id
  policy = each.value.json
}
