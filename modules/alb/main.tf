locals {
  load_balancer_type = "application"
}

################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = local.load_balancer_type
  internal           = var.internal

  subnets         = var.subnets_ids
  security_groups = var.security_groups_ids

  preserve_host_header = var.preserve_host_header

  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

################################################################################
# Load Balancer Target Group
################################################################################

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = each.value.name
  vpc_id      = each.value.vpc_id
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type

  dynamic "health_check" {
    for_each = try(each.value.health_check, null) != null ? [1] : []

    content {
      enabled             = try(each.value.health_check.enabled, null)
      healthy_threshold   = try(each.value.health_check.healthy_threshold, null)
      interval            = try(each.value.health_check.interval, null)
      matcher             = try(each.value.health_check.matcher, null)
      path                = try(each.value.health_check.path, null)
      port                = try(each.value.health_check.port, null)
      protocol            = try(each.value.health_check.protocol, null)
      timeout             = try(each.value.health_check.timeout, null)
      unhealthy_threshold = try(each.value.health_check.unhealthy_threshold, null)
    }
  }

  tags = each.value.tags
}

################################################################################
# Load Balancer Listener
################################################################################

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn

  certificate_arn = each.value.certificate_arn
  port            = each.value.port
  protocol        = each.value.protocol
  ssl_policy      = each.value.ssl_policy

  dynamic "default_action" {
    for_each = each.value.default_action
    iterator = default_action

    content {
      type             = default_action.value.type
      target_group_arn = aws_lb_target_group.this[default_action.value.target_group].arn
      order            = default_action.value.order

      dynamic "fixed_response" {
        for_each = try(default_action.value.fixed_response, null) != null ? [1] : []

        content {
          content_type = default_action.value.fixed_response.content_type
          message_body = try(default_action.value.fixed_response.message_body, null)
          status_code  = try(default_action.value.fixed_response.status_code, null)
        }
      }

      dynamic "forward" {
        for_each = try(default_action.value.forward, null) != null ? [1] : []

        content {
          dynamic "target_group" {
            for_each = default_action.value.forward.target_group
            iterator = target_group

            content {
              arn    = target_group.value.arn
              weight = target_group.value.weight
            }
          }

          dynamic "stickiness" {
            for_each = try(default_action.value.forward.stickiness, null) != null ? [1] : []

            content {
              duration = default_action.value.forward.stickiness.duration
              enabled  = try(default_action.value.forward.stickiness.enabled, false)
            }
          }
        }
      }

      dynamic "redirect" {
        for_each = try(default_action.value.redirect, null) != null ? [1] : []

        content {
          status_code = default_action.value.redirect.status_code
          host        = try(default_action.value.redirect.host, null)
          path        = try(default_action.value.redirect.path, null)
          port        = try(default_action.value.redirect.port, null)
          protocol    = try(default_action.value.redirect.protocol, null)
          query       = try(default_action.value.redirect.query, null)
        }
      }
    }
  }

  tags = each.value.tags
}
