locals {
  load_balancer_type = "application"
}

################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "this" {
  name                       = try(var.name, null)
  load_balancer_type         = try(local.load_balancer_type, null)
  internal                   = try(var.internal, null)
  subnets                    = var.subnets_ids
  security_groups            = var.security_groups_ids
  preserve_host_header       = var.preserve_host_header
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

################################################################################
# Load Balancer Target Group
################################################################################

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = try(each.value.name, null)
  vpc_id      = try(each.value.vpc_id, null)
  port        = try(each.value.port, null)
  protocol    = try(each.value.protocol, null)
  target_type = try(each.value.target_type, null)

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

  certificate_arn = try(each.value.certificate_arn, null)
  port            = try(each.value.port, null)
  protocol        = try(each.value.protocol, null)
  ssl_policy      = try(each.value.ssl_policy, null)

  dynamic "default_action" {
    for_each = each.value.default_action
    iterator = default_action

    content {
      type             = default_action.value.type
      target_group_arn = aws_lb_target_group.this[default_action.value.target_group].arn
      order            = try(default_action.value.order, null)

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
              weight = try(target_group.value.weight, null)
            }
          }

          dynamic "stickiness" {
            for_each = try(default_action.value.forward.stickiness, null) != null ? [1] : []

            content {
              duration = default_action.value.forward.stickiness.duration
              enabled  = try(default_action.value.forward.stickiness.enabled, null)
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

################################################################################
# Load Balancer Listener Rule
################################################################################

resource "aws_lb_listener_rule" "this" {
  for_each = var.listener_rules

  listener_arn = aws_lb_listener.this[each.value.listener].arn
  priority     = try(each.value.priority, null)

  dynamic "action" {
    for_each = each.value.action

    content {
      type = action.value.type
      target_group_arn = lookup(
        aws_lb_target_group.this,
        try(action.value.target_group, null) != null ? try(action.value.target_group, "") : "",
        null
      ) != null ? aws_lb_target_group.this[try(action.value.target_group, null)].arn : null

      dynamic "authenticate_oidc" {
        for_each = try(action.value.authenticate_oidc, null) != null ? [1] : []

        content {
          authorization_endpoint     = action.value.authenticate_oidc.authorization_endpoint
          client_id                  = action.value.authenticate_oidc.client_id
          client_secret              = action.value.authenticate_oidc.client_secret
          issuer                     = action.value.authenticate_oidc.issuer
          on_unauthenticated_request = try(action.value.authenticate_oidc.on_unauthenticated_request, null)
          scope                      = try(action.value.authenticate_oidc.scope, null)
          session_cookie_name        = try(action.value.authenticate_oidc.session_cookie_name, null)
          token_endpoint             = action.value.authenticate_oidc.token_endpoint
          user_info_endpoint         = action.value.authenticate_oidc.user_info_endpoint
        }
      }
    }
  }

  dynamic "condition" {
    for_each = each.value.condition

    content {
      dynamic "host_header" {
        for_each = try(condition.value.host_header, null) != null ? [1] : []

        content {
          values = condition.value.host_header.values
        }
      }

      dynamic "path_pattern" {
        for_each = try(condition.value.path_pattern, null) != null ? [1] : []

        content {
          values = condition.value.path_pattern.values
        }
      }

      dynamic "http_request_method" {
        for_each = try(condition.value.http_request_method, null) != null ? [1] : []

        content {
          values = condition.value.http_request_method.values
        }
      }
    }
  }

  tags = each.value.tags
}
