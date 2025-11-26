provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "cross_account_provider"
  region = var.region

  assume_role {
    role_arn = var.route53_assume_role_arn
  }
}

locals {
  task_definition_network_mode = "awsvpc"
x
  capacity_provider_default_strategies_weight = 1
  capacity_provider_default_strategies_base   = 0

  acm_validation_method = "DNS"

  alb_internal = false

  target_group_key_name    = "default-nginx"
  target_group_target_type = "ip"

  listener_default_action_type = "forward"
}

################################################################################
# ECS Deployment Module
################################################################################

module "ecs_deployment" {
  source = "../../"

  providers = {
    aws                        = aws
    aws.cross_account_provider = aws.cross_account_provider
  }

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id

  # ECS
  service = {
    name                 = var.container_name
    desired_count        = var.service_desired_count
    force_new_deployment = true

    network_configuration = {
      security_groups = var.service_network_configuration_security_groups
      subnets         = var.private_subnets
    }

    load_balancer = [
      {
        target_group   = local.target_group_key_name
        container_name = var.container_name
        container_port = var.container_port
      }
    ]
  }
  task_definition = {
    family       = var.container_name
    network_mode = local.task_definition_network_mode

    cpu    = var.container_cpu
    memory = var.container_memory

    container_definitions = [
      {
        name                   = var.container_name
        image                  = var.container_image
        cpu                    = var.container_cpu
        memory                 = var.container_memory
        essential              = var.container_essential
        portMappings           = var.container_port_mappings
        readonlyRootFilesystem = var.container_readonly_root_filesystem
      }
    ]
  }

  # Capacity Provider
  capacity_provider_default_auto_scaling_group_arn = var.asg_arn
  capacity_providers = {
    capacity_provider = {
      name                           = var.capacity_provider_name
      managed_termination_protection = "DISABLED"
      managed_scaling                = var.capacity_provider_managed_scaling
    }
  }
  default_capacity_providers_strategies = [
    {
      capacity_provider = "capacity_provider"
      weight            = local.capacity_provider_default_strategies_weight
      base              = local.capacity_provider_default_strategies_base
    }
  ]

  # Amazon Certificates Manager
  create_acm = true
  acm_certificates = {
    base_domain = {
      domain_name       = var.domain_name
      validation_method = local.acm_validation_method
      record_zone_id    = data.aws_route53_zone.base_domain.zone_id
    }
  }
  # Cross-account role that ACM module will use for Route53 DNS record creation
  route53_assume_role_arn = var.route53_assume_role_arn

  # Application Load Balancer
  load_balancer = {
    name                = var.alb_name
    internal            = local.alb_internal
    security_groups_ids = [aws_security_group.alb_allow_all.id]
    subnets_ids         = var.public_subnets

    target_groups = {
      (local.target_group_key_name) = {
        name        = var.target_group_name
        port        = var.container_port
        protocol    = var.target_group_protocol
        target_type = local.target_group_target_type

        health_check = var.target_group_health_check
      }
    }

    listeners = {
      this = {
        port        = var.listener_port
        protocol    = "HTTPS"
        certificate = "base_domain"
        ssl_policy  = var.ssl_policy

        default_action = [
          {
            type         = local.listener_default_action_type
            target_group = local.target_group_key_name
          }
        ]
      }
    }
  }

  # S3 Bucket
  s3_bucket_force_destroy = var.s3_bucket_force_destroy
}

################################################################################
# ACM
################################################################################

data "aws_route53_zone" "base_domain" {
  name = var.base_domain
}

################################################################################
# Security Groups
################################################################################

resource "aws_security_group" "alb_allow_all" {
  name        = var.security_group_alb
  description = "Allow all ingress and egress traffic within Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
