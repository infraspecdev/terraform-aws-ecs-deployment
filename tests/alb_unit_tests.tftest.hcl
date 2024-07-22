provider "aws" {
  region = "ap-south-1"
}

################################################################################
# Load Balancer
################################################################################

run "lb_attributes_match" {
  command = plan

  module {
    source = "./modules/alb"
  }

  variables {
    name                       = "example-name"
    internal                   = true
    subnets_ids                = ["subnet-1234567890123", "subnet-1234567890124"]
    security_groups_ids        = ["sg-123456789012345", "sg-123456789012346"]
    preserve_host_header       = true
    enable_deletion_protection = true

    listeners = {}

    tags = {
      Example = "Tag"
    }
  }

  assert {
    condition     = aws_lb.this.name == var.name
    error_message = "Names mismatch"
  }

  assert {
    condition     = aws_lb.this.internal == var.internal
    error_message = "Internal mismatch"
  }

  assert {
    condition     = tolist(aws_lb.this.subnets) == var.subnets_ids
    error_message = "Subnets mismatch"
  }
  assert {
    condition     = tolist(aws_lb.this.security_groups) == var.security_groups_ids
    error_message = "Security groups ids mismatch"
  }

  assert {
    condition     = aws_lb.this.preserve_host_header == var.preserve_host_header
    error_message = "Preserve host header mismatch"
  }

  assert {
    condition     = aws_lb.this.enable_deletion_protection == var.enable_deletion_protection
    error_message = "Enable deletion protection mismatch"
  }

  assert {
    condition     = aws_lb.this.tags == var.tags
    error_message = "Tags mismatch"
  }
}

################################################################################
# Load Balancer Target Group
################################################################################

run "lb_target_group_attributes_match" {
  command = plan

  module {
    source = "./modules/alb"
  }

  variables {
    name                       = "example-name"
    internal                   = true
    subnets_ids                = ["subnet-1234567890123", "subnet-1234567890124"]
    security_groups_ids        = ["sg-123456789012345", "sg-123456789012346"]
    preserve_host_header       = true
    enable_deletion_protection = true

    target_groups = {
      this = {
        name        = "example-name"
        vpc_id      = "vpc-0123456789abcdef0"
        port        = 1234
        protocol    = "HTTPS"
        target_type = "ip"

        health_check = {
          enabled             = true
          healthy_threshold   = 7
          interval            = 180
          matcher             = "200,299"
          path                = "/example/path"
          port                = 1234
          protocol            = "HTTPS"
          timeout             = 70
          unhealthy_threshold = 6
        }
      }
    }

    listeners = {}

    tags = {
      Example = "Tag"
    }
  }

  assert {
    condition     = aws_lb_target_group.this["this"].name == var.target_groups["this"].name
    error_message = "Name mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].vpc_id == var.target_groups["this"].vpc_id
    error_message = "VPC ID mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].port == var.target_groups["this"].port
    error_message = "Port mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].protocol == var.target_groups["this"].protocol
    error_message = "Protocol mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].target_type == var.target_groups["this"].target_type
    error_message = "Target type mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].enabled == var.target_groups["this"].health_check.enabled
    error_message = "Health check enabled mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].healthy_threshold == var.target_groups["this"].health_check.healthy_threshold
    error_message = "Healthy threshold mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].interval == var.target_groups["this"].health_check.interval
    error_message = "Interval mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].matcher == var.target_groups["this"].health_check.matcher
    error_message = "Matcher mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].path == var.target_groups["this"].health_check.path
    error_message = "Path mismatch"
  }

  assert {
    condition     = tonumber(aws_lb_target_group.this["this"].health_check[0].port) == var.target_groups["this"].health_check.port
    error_message = "Port mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].protocol == var.target_groups["this"].health_check.protocol
    error_message = "Protocol mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].timeout == var.target_groups["this"].health_check.timeout
    error_message = "Timeout mismatch"
  }

  assert {
    condition     = aws_lb_target_group.this["this"].health_check[0].unhealthy_threshold == var.target_groups["this"].health_check.unhealthy_threshold
    error_message = "Unhealthy threshold mismatch"
  }
}

################################################################################
# Load Balancer Listener
################################################################################

run "lb_listener_attributes_match" {
  command = plan

  module {
    source = "./modules/alb"
  }

  variables {
    name                       = "example-name"
    internal                   = true
    subnets_ids                = ["subnet-1234567890123", "subnet-1234567890124"]
    security_groups_ids        = ["sg-123456789012345", "sg-123456789012346"]
    preserve_host_header       = true
    enable_deletion_protection = true

    target_groups = {
      this = {
        port        = 1234
        protocol    = "HTTPS"
        target_type = "ip"
        vpc_id      = "vpc-0123456789abcdef0"
      }
    }

    listeners = {
      this = {
        alpn_policy     = "HTTP2Preferred"
        certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012"
        port            = 1234
        protocol        = "HTTPS"
        ssl_policy      = "ExampleSSLPolicy"

        default_action = [
          {
            type         = "forward"
            target_group = "this"
          }
        ]
      }
    }

    tags = {
      Example = "Tag"
    }
  }

  assert {
    condition     = aws_lb_listener.this["this"].alpn_policy == var.listeners["this"].alpn_policy
    error_message = "ALPN policy mismatch"
  }

  assert {
    condition     = aws_lb_listener.this["this"].certificate_arn == var.listeners["this"].certificate_arn
    error_message = "Certificate ARN mismatch"
  }

  assert {
    condition     = aws_lb_listener.this["this"].port == var.listeners["this"].port
    error_message = "Port mismatch"
  }

  assert {
    condition     = aws_lb_listener.this["this"].protocol == var.listeners["this"].protocol
    error_message = "Protocol mismatch"
  }

  assert {
    condition     = aws_lb_listener.this["this"].ssl_policy == var.listeners["this"].ssl_policy
    error_message = "SSL Policy mismatch"
  }
}

run "lb_listener_default_action_attributes_match" {
  command = plan

  module {
    source = "./modules/alb"
  }

  variables {
    name                       = "example-name"
    internal                   = true
    subnets_ids                = ["subnet-1234567890123", "subnet-1234567890124"]
    security_groups_ids        = ["sg-123456789012345", "sg-123456789012346"]
    preserve_host_header       = true
    enable_deletion_protection = true

    target_groups = {
      this = {
        port        = 1234
        protocol    = "HTTPS"
        target_type = "ip"
        vpc_id      = "vpc-0123456789abcdef0"
      }
    }

    listeners = {
      this = {
        alpn_policy     = "HTTP2Preferred"
        certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012"
        port            = 1234
        protocol        = "HTTPS"
        ssl_policy      = "ExampleSSLPolicy"

        default_action = [
          {
            type         = "forward"
            target_group = "this"
            order        = 1

            authenticate_cognito = {
              user_pool_arn       = "arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_ABCDEFG"
              user_pool_client_id = "1234567890abcdefg"
              user_pool_domain    = "example.auth.us-east-1.amazoncognito.com"
              authentication_request_extra_params = {
                key   = "example_key"
                value = "example_value"
              }
              on_unauthenticated_request = "deny"
              scope                      = "openid profile email"
              session_cookie_name        = "AWSELBAuthSessionCookie"
              session_timeout            = 604800
            }
            authenticate_oidc = {
              authorization_endpoint = "https://example.com/authz"
              client_id              = "dummy_client_id"
              client_secret          = "dummy_client_secret"
              issuer                 = "https://example.com/issuer"
              token_endpoint         = "https://example.com/token"
              user_info_endpoint     = "https://example.com/userinfo"
              authentication_request_extra_params = {
                example = "param"
              }
              on_unauthenticated_request = "deny"
              scope                      = "openid profile email"
              session_cookie_name        = "AWSELBAuthSessionCookie"
              session_timeout            = 604800
            }
            fixed_response = {
              content_type : "application/json",
              message_body : "{\"message\": \"Hello from Load Balancer\"}",
              status_code : 200
            }
            forward = {
              target_group = [
                {
                  arn    = "tg-123456789012345",
                  weight = 1
                },
                {
                  arn    = "tg-123456789012346",
                  weight = 2
                }
              ]
              stickiness = {
                duration = 100
                enabled  = true
              }
            }
            redirect = {
              status_code = 302
              host        = "example.com"
              path        = "/new-path"
              port        = 443
              protocol    = "https"
              query       = "param1=value1&param2=value2"
            }
          }
        ]
      }
    }

    tags = {
      Example = "Tag"
    }
  }

  assert {
    condition     = aws_lb_listener.this["this"].default_action[0].type == var.listeners["this"].default_action[0].type
    error_message = "Type mismatch"
  }

  assert {
    condition     = aws_lb_listener.this["this"].default_action[0].order == var.listeners["this"].default_action[0].order
    error_message = "Order mismatch"
  }
}
