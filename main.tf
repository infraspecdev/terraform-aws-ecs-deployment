locals {
  # ACM
  acm_certificates_arns = var.create_acm ? merge(
    try(module.acm[0].amazon_issued_acm_certificates_arns, {}),
    try(module.acm[0].imported_acm_certificates_arns, {}),
    try(module.acm[0].private_ca_issued_acm_certificates_arns, {})
  ) : {}

  # ALB
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
          local.acm_certificates_arns,
          try(v.certificate, null) != null ? try(v.certificate, "") : "",
          null
        ) != null ? local.acm_certificates_arns[try(v.certificate, null)] : try(v.certificate_arn, null)
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
  enable_ecs_managed_tags            = try(var.service.enable_ecs_managed_tags, true)
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
    for_each = length(try(var.service.network_configuration, {})) > 0 ? [1] : []

    content {
      subnets          = var.service.network_configuration.subnets
      security_groups  = try(var.service.network_configuration.security_groups, [])
      assign_public_ip = try(var.service.network_configuration.assign_public_ip, false)
    }
  }

  dynamic "service_connect_configuration" {
    for_each = length(try(var.service.service_connect_configuration, {})) > 0 ? [1] : []

    content {
      enabled   = var.service.service_connect_configuration.enabled
      namespace = try(var.service.service_connect_configuration.namespace, null)

      dynamic "log_configuration" {
        for_each = length(try(var.service.service_connect_configuration.log_configuration, {})) > 0 ? [1] : []

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
            for_each = length(try(service.client_alias, {})) > 0 ? [1] : []

            content {
              port     = service.client_alias.port
              dns_name = try(service.client_alias.dns_name, null)
            }
          }
        }
      }
    }
  }

  dynamic "volume_configuration" {
    for_each = length(try(var.service.volume_configuration, {})) > 0 ? [1] : []

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
    for_each = length(try(var.service.deployment_circuit_breaker, {})) > 0 ? [1] : []

    content {
      enable   = var.service.deployment_circuit_breaker.enabled
      rollback = var.service.deployment_circuit_breaker.rollback
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
    for_each = length(try(var.task_definition.runtime_platform, {})) > 0 ? [1] : []

    content {
      operating_system_family = try(var.task_definition.runtime_platform.operating_system_family, null)
      cpu_architecture        = try(var.task_definition.runtime_platform.cpu_architecture, null)
    }
  }

  dynamic "volume" {
    for_each = try(var.task_definition.volume, [])
    iterator = volume

    content {
      name                = volume.value.name
      configure_at_launch = try(volume.value.configure_at_launch, null)
      host_path           = try(volume.value.host_path, null)

      dynamic "docker_volume_configuration" {
        for_each = length(try(volume.value.docker_volume_configuration, {})) > 0 ? [1] : []

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

  target_groups = local.alb_target_groups

  listeners = local.alb_listeners

  listener_rules = try(var.load_balancer.listener_rules, {})

  tags = try(var.load_balancer.tags, {})
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

module "acm" {
  source = "./modules/acm"

  count = var.create_acm ? 1 : 0

  amazon_issued_certificates = try(var.acm_amazon_issued_certificates, {})
  imported_certificates      = try(var.acm_imported_certificates, {})
}
