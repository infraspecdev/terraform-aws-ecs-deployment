locals {
  # ALB
  alb_access_logs_default_s3_configuration = var.create_s3_bucket_for_alb_logging ? {
    bucket  = module.s3_bucket[0].bucket_id
    enabled = true
    prefix  = var.s3_bucket_access_logs_prefix
  } : null
  alb_connection_logs_default_s3_configuration = var.create_s3_bucket_for_alb_logging ? {
    bucket  = module.s3_bucket[0].bucket_id
    enabled = true
    prefix  = var.s3_bucket_connection_logs_prefix
  } : null
  alb_target_groups = {
    for k, v in try(var.load_balancer.target_groups, {}) :
    k => merge(
      {
        vpc_id = var.vpc_id
      },
      v
    )
  }
  alb_listeners = {
    for k, v in try(var.load_balancer.listeners, {}) :
    k => merge(
      {
        certificate_arn = lookup(
          var.acm_certificates,
          try(v.certificate, null) != null ? try(v.certificate, "") : "",
          null
        ) != null ? module.acm[try(v.certificate, null)].acm_certificate_arn : try(v.certificate_arn, null)
      },
      v
    )
  }
}

################################################################################
# ECS Service
################################################################################

resource "aws_ecs_service" "this" {
  name    = var.service.name
  cluster = var.cluster_name

  deployment_maximum_percent         = try(var.service.deployment_maximum_percent, null)
  deployment_minimum_healthy_percent = try(var.service.deployment_minimum_healthy_percent, null)
  desired_count                      = try(var.service.desired_count, null)
  enable_ecs_managed_tags            = try(var.service.enable_ecs_managed_tags, null)
  enable_execute_command             = try(var.service.enable_execute_command, null)
  force_new_deployment               = try(var.service.force_new_deployment, null)
  health_check_grace_period_seconds  = try(var.service.health_check_grace_period_seconds, null)
  iam_role                           = try(var.service.iam_role, null)
  launch_type                        = "EC2"
  propagate_tags                     = try(var.service.propagate_tags, null)
  scheduling_strategy                = try(var.service.scheduling_strategy, null)
  task_definition                    = aws_ecs_task_definition.this.id
  triggers                           = try(var.service.triggers, null)
  wait_for_steady_state              = try(var.service.wait_for_steady_state, null)

  dynamic "load_balancer" {
    for_each = try(var.service.load_balancer, [])
    iterator = load_balancer

    content {
      elb_name = try(load_balancer.value.elb_name, null)
      target_group_arn = lookup(
        try(module.alb[0].target_groups_arns, {}),
        try(load_balancer.value.target_group, null) != null ? try(load_balancer.value.target_group, "") : "",
        null
      ) != null ? try(module.alb[0].target_groups_arns, {})[try(load_balancer.value.target_group, null)] : try(load_balancer.value.target_group_arn, null)
      container_name = load_balancer.value.container_name
      container_port = load_balancer.value.container_port
    }
  }

  dynamic "network_configuration" {
    for_each = try(var.service.network_configuration, null) != null ? [1] : []

    content {
      subnets          = var.service.network_configuration.subnets
      security_groups  = try(var.service.network_configuration.security_groups, [])
      assign_public_ip = try(var.service.network_configuration.assign_public_ip, false)
    }
  }

  dynamic "service_connect_configuration" {
    for_each = try(var.service.service_connect_configuration, null) != null ? [1] : []

    content {
      enabled   = var.service.service_connect_configuration.enabled
      namespace = try(var.service.service_connect_configuration.namespace, null)

      dynamic "log_configuration" {
        for_each = try(var.service.service_connect_configuration.log_configuration, null) != null ? [1] : []

        content {
          log_driver = var.service.service_connect_configuration.log_configuration.log_driver
          options    = try(var.service.service_connect_configuration.log_configuration.options, null)
        }
      }

      dynamic "service" {
        for_each = try(var.service.service_connect_configuration.service, [])
        iterator = service

        content {
          port_name             = service.value.port_name
          discovery_name        = try(service.value.discovery_name, null)
          ingress_port_override = try(service.value.ingress_port_override, null)

          dynamic "client_alias" {
            for_each = try(service.value.client_alias, null) != null ? [1] : []

            content {
              port     = service.value.client_alias.port
              dns_name = try(service.value.client_alias.dns_name, null)
            }
          }

          dynamic "timeout" {
            for_each = try(service.value.timeout, null) != null ? [1] : []

            content {
              idle_timeout_seconds        = try(service.value.timeout.idle_timeout_seconds, null)
              per_request_timeout_seconds = try(service.value.timeout.per_request_timeout_seconds, null)
            }
          }
        }
      }
    }
  }

  dynamic "volume_configuration" {
    for_each = try(var.service.volume_configuration, null) != null ? [1] : []

    content {
      name = var.service.volume_configuration.name

      managed_ebs_volume {
        role_arn         = var.service.volume_configuration.managed_ebs_volume.role_arn
        encrypted        = try(var.service.volume_configuration.managed_ebs_volume.encrypted, null)
        file_system_type = try(var.service.volume_configuration.managed_ebs_volume.file_system_type, null)
        iops             = try(var.service.volume_configuration.managed_ebs_volume.iops, null)
        kms_key_id       = try(var.service.volume_configuration.managed_ebs_volume.kms_key_id, null)
        size_in_gb       = try(var.service.volume_configuration.managed_ebs_volume.size_in_gb, null)
        snapshot_id      = try(var.service.volume_configuration.managed_ebs_volume.snapshot_id, null)
        throughput       = try(var.service.volume_configuration.managed_ebs_volume.throughput, null)
        volume_type      = try(var.service.volume_configuration.managed_ebs_volume.volume_type, null)
      }
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = try(var.service.deployment_circuit_breaker, null) != null ? [1] : []

    content {
      enable   = var.service.deployment_circuit_breaker.enabled
      rollback = var.service.deployment_circuit_breaker.rollback
    }
  }

  dynamic "service_registries" {
    for_each = try(var.service.service_registries, null) != null ? [1] : []

    content {
      registry_arn   = var.service.service_registries.registry_arn
      port           = try(var.service.service_registries.port, null)
      container_name = try(var.service.service_registries.container_name, null)
      container_port = try(var.service.service_registries.container_port, null)
    }
  }

  tags = try(var.service.tags, {})
}

################################################################################
# ECS Task Definition
################################################################################

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode(var.task_definition.container_definitions)
  family                = try(var.task_definition.family, null)

  cpu                      = try(var.task_definition.cpu, null)
  execution_role_arn       = try(var.task_definition.execution_role_arn, null)
  ipc_mode                 = try(var.task_definition.ipc_mode, null)
  memory                   = try(var.task_definition.memory, null)
  network_mode             = try(var.task_definition.network_mode, null)
  pid_mode                 = try(var.task_definition.pid_mode, null)
  requires_compatibilities = ["EC2"]
  skip_destroy             = try(var.task_definition.skip_destroy, null)
  task_role_arn            = try(var.task_definition.task_role_arn, null)
  track_latest             = try(var.task_definition.track_latest, null)

  dynamic "runtime_platform" {
    for_each = try(var.task_definition.runtime_platform, null) != null ? [1] : []

    content {
      operating_system_family = try(var.task_definition.runtime_platform.operating_system_family, null)
      cpu_architecture        = try(var.task_definition.runtime_platform.cpu_architecture, null)
    }
  }

  dynamic "volume" {
    for_each = try(var.task_definition.volume != null ? var.task_definition.volume : [], [])
    iterator = volume

    content {
      name                = volume.value.name
      configure_at_launch = try(volume.value.configure_at_launch, null)
      host_path           = try(volume.value.host_path, null)

      dynamic "docker_volume_configuration" {
        for_each = try(volume.value.docker_volume_configuration, null) != null ? [1] : []

        content {
          autoprovision = try(volume.value.docker_volume_configuration.autoprovision, null)
          driver_opts   = try(volume.value.docker_volume_configuration.driver_opts, null)
          driver        = try(volume.value.docker_volume_configuration.driver, null)
          labels        = try(volume.value.docker_volume_configuration.labels, null)
          scope         = try(volume.value.docker_volume_configuration.scope, null)
        }
      }
    }
  }

  tags = try(var.task_definition.tags, {})
}

################################################################################
# Capacity Provider Sub-module
################################################################################

module "capacity_provider" {
  source = "./modules/capacity-provider"

  count = var.create_capacity_provider ? 1 : 0

  ecs_cluster_name               = var.cluster_name
  default_auto_scaling_group_arn = var.capacity_provider_default_auto_scaling_group_arn

  capacity_providers                   = var.capacity_providers
  default_capacity_provider_strategies = var.default_capacity_providers_strategies
}

################################################################################
# Application Load Balancer Sub-module
################################################################################

module "alb" {
  source = "./modules/alb"

  count = var.create_alb ? 1 : 0

  name                       = try(var.load_balancer.name, null)
  internal                   = try(var.load_balancer.internal, null)
  subnets_ids                = try(var.load_balancer.subnets_ids, [])
  security_groups_ids        = try(var.load_balancer.security_groups_ids, [])
  preserve_host_header       = try(var.load_balancer.preserve_host_header, null)
  enable_deletion_protection = try(var.load_balancer.enable_deletion_protection, null)

  access_logs     = var.load_balancer.access_logs != null ? var.load_balancer.access_logs : local.alb_access_logs_default_s3_configuration
  connection_logs = var.load_balancer.connection_logs != null ? var.load_balancer.connection_logs : local.alb_connection_logs_default_s3_configuration

  target_groups = local.alb_target_groups

  listeners = local.alb_listeners

  listener_rules = try(var.load_balancer.listener_rules, {})

  tags = try(var.load_balancer.tags, {})

  depends_on = [module.acm]
}

################################################################################
# S3 Bucket Sub-module
################################################################################

data "aws_elb_service_account" "this" {}

module "s3_bucket" {
  source = "./modules/s3-bucket"

  count = var.create_s3_bucket_for_alb_logging ? 1 : 0

  bucket               = var.s3_bucket_name
  bucket_force_destroy = var.s3_bucket_force_destroy

  bucket_policies = {
    alb-logs = {
      id = "${var.s3_bucket_policy_id_prefix}-logs"

      statements = [
        {
          sid = "AllowAccessToS3Bucket"

          effect = "Allow"
          resources = [
            "${module.s3_bucket[0].bucket_arn}/*",
          ]
          actions = [
            "s3:PutObject",
          ]

          principals = [
            {
              identifiers = [
                data.aws_elb_service_account.this.arn
              ]
              type = "AWS"
            }
          ]
        },
        {
          sid = "AllowPutObjectToS3Bucket"

          effect = "Allow"
          resources = [
            "${module.s3_bucket[0].bucket_arn}/*"
          ]
          actions = [
            "s3:PutObject"
          ]

          principals = [
            {
              identifiers = ["delivery.logs.amazonaws.com"]
              type        = "Service"
            }
          ]
        },
        {
          sid = "AllowGetBucketAclFromS3Bucket"

          effect = "Allow"
          resources = [
            module.s3_bucket[0].bucket_arn
          ]
          actions = [
            "s3:GetBucketAcl"
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

  tags = var.s3_bucket_tags
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

module "acm" {
  source = "./modules/acm"

  for_each = var.create_acm ? var.acm_certificates : {}

  certificate_domain_name               = each.value.domain_name
  certificate_subject_alternative_names = try(each.value.subject_alternative_names, null)
  certificate_validation_method         = try(each.value.validation_method, null)
  certificate_key_algorithm             = try(each.value.key_algorithm, null)
  certificate_validation_option         = try(each.value.validation_option, null)

  record_zone_id         = try(each.value.record_zone_id, null)
  record_allow_overwrite = try(each.value.record_allow_overwrite, null)

  tags = try(each.value.tags, {})
}
