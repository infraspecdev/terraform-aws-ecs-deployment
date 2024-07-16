################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = "application"
  internal           = var.internal

  subnets         = var.subnets_ids
  security_groups = var.security_groups_ids

  preserve_host_header = var.preserve_host_header

  enable_deletion_protection = false

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
    for_each = length(try(each.value.health_check, {})) > 0 ? [1] : []

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
  count = length(var.listeners)

  load_balancer_arn = aws_lb.this.arn

  alpn_policy     = element(var.listeners, count.index).alpn_policy
  certificate_arn = element(var.listeners, count.index).certificate_arn
  port            = element(var.listeners, count.index).port
  protocol        = element(var.listeners, count.index).protocol
  ssl_policy      = element(var.listeners, count.index).ssl_policy

  dynamic "mutual_authentication" {
    for_each = length(try(element(var.listeners, count.index).mutual_authentication, {})) > 0 ? [1] : []

    content {
      mode                             = element(var.listeners, count.index).mutual_authentication.mode
      trust_store_arn                  = element(var.listeners, count.index).mutual_authentication.trust_store_arn
      ignore_client_certificate_expiry = try(element(var.listeners, count.index).mutual_authentication.ignore_client_certificate_expiry, null)
    }
  }

  dynamic "default_action" {
    for_each = element(var.listeners, count.index).default_action
    iterator = default_action

    content {
      type             = default_action.value.type
      target_group_arn = aws_lb_target_group.this[default_action.value.target_group]
      order            = default_action.value.order

      dynamic "authenticate_cognito" {
        for_each = length(try(default_action.value.authenticate_cognito, {})) > 0 ? [1] : []

        content {
          user_pool_arn                       = default_action.value.authenticate_cognito.user_pool_arn
          user_pool_client_id                 = default_action.value.authenticate_cognito.user_pool_client_id
          user_pool_domain                    = default_action.value.authenticate_cognito.user_pool_domain
          authentication_request_extra_params = try(default_action.value.authenticate_cognito.authentication_request_extra_params, null)
          on_unauthenticated_request          = try(default_action.value.authenticate_cognito.on_unauthenticated_request, null)
          scope                               = try(default_action.value.authenticate_cognito.scope, null)
          session_cookie_name                 = try(default_action.value.authenticate_cognito.session_cookie_name, null)
          session_timeout                     = try(default_action.value.authenticate_cognito.session_timeout, null)
        }
      }

      dynamic "authenticate_oidc" {
        for_each = length(try(default_action.value.authenticate_oidc, {})) > 0 ? [1] : []

        content {
          authorization_endpoint              = default_action.value.authenticate_oidc.authorization_endpoint
          client_id                           = default_action.value.authenticate_oidc.client_id
          client_secret                       = default_action.value.authenticate_oidc.client_secret
          issuer                              = default_action.value.authenticate_oidc.issuer
          token_endpoint                      = default_action.value.authenticate_oidc.token_endpoint
          user_info_endpoint                  = default_action.value.authenticate_oidc.user_info_endpoint
          authentication_request_extra_params = try(default_action.value.authenticate_oidc.authentication_request_extra_params, null)
          on_unauthenticated_request          = try(default_action.value.authenticate_oidc.on_unauthenticated_request, null)
          scope                               = try(default_action.value.authenticate_oidc.scope, null)
          session_cookie_name                 = try(default_action.value.authenticate_oidc.session_cookie_name, null)
          session_timeout                     = try(default_action.value.authenticate_oidc.session_timeout, null)
        }
      }

      dynamic "fixed_response" {
        for_each = length(try(default_action.value.fixed_response, {})) > 0 ? [1] : []

        content {
          content_type = default_action.value.fixed_response.content_type
          message_body = try(default_action.value.fixed_response.message_body, null)
          status_code  = try(default_action.value.fixed_response.status_code, null)
        }
      }

      dynamic "forward" {
        for_each = length(try(default_action.value.forward, {})) > 0 ? [1] : []

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
            for_each = length(try(default_action.value.forward.stickiness, {})) > 0 ? [1] : []

            content {
              duration = default_action.value.forward.stickiness.duration
              enabled  = try(default_action.value.forward.stickiness.enabled, false)
            }
          }
        }
      }

      dynamic "redirect" {
        for_each = length(try(default_action.value.redirect, {})) ? [1] : []

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

  tags = element(var.listeners, count.index).tags
}
