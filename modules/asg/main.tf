################################################################################
# Autoscaling Group
################################################################################

resource "aws_autoscaling_group" "this" {
  name                = var.name
  vpc_zone_identifier = var.vpc_zone_identifier

  desired_capacity      = var.desired_capacity
  min_size              = var.min_size
  max_size              = var.max_size
  protect_from_scale_in = try(var.protect_from_scale_in, null)

  health_check_type = "EC2"

  launch_template {
    id = var.create_launch_template ? aws_launch_template.this[0].id : var.launch_template_id
  }

  dynamic "tag" {
    for_each = var.instances_tags

    content {
      key                 = each.key
      value               = each.value
      propagate_at_launch = true
    }
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = each.key
      value               = each.value
      propagate_at_launch = false
    }
  }
}

################################################################################
# Launch Template
################################################################################

resource "aws_launch_template" "this" {
  count = var.create_launch_template ? 1 : 0

  name                   = var.launch_template.name
  image_id               = var.launch_template.image_id
  instance_type          = var.launch_template.instance_type
  vpc_security_group_ids = var.launch_template.vpc_security_group_ids
  key_name               = var.launch_template.key_name

  iam_instance_profile {
    name = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile_name
  }

  user_data = try(var.launch_template.user_data, null) != null ? base64encode(var.launch_template.user_data) : null

  tags = var.launch_template.tags
}

################################################################################
# IAM Instance Profile
################################################################################

data "aws_iam_policy_document" "this" {
  count = var.create_iam_role && var.create_iam_instance_profile ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_iam_role && var.create_iam_instance_profile ? 1 : 0

  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.this[0].json

  tags = var.iam_role_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.create_iam_role && var.create_iam_instance_profile ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = var.iam_role_ec2_container_service_role_arn
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = var.iam_instance_profile_name
  role = aws_iam_role.this[0].name

  tags = var.iam_instance_profile_tags
}
