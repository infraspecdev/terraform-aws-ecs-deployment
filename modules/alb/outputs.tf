################################################################################
# Load Balancer
################################################################################

output "id" {
  description = "Identifier of the Load Balancer"
  value       = aws_lb.this.id
}

output "arn" {
  description = "ARN of the Load Balancer"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "Canonical hosted zone ID of the Load Balancer (to be used in a Route 53 Alias record)"
  value       = aws_lb.this.zone_id
}

################################################################################
# Load Balancer Target Group
################################################################################

output "target_groups_ids" {
  description = "Identifiers of the Target Groups"
  value       = { for k, v in aws_lb_target_group.this : k => v.id }
}

output "target_groups_arns" {
  description = "ARNs of the Target Groups"
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

################################################################################
# Load Balancer Listeners
################################################################################

output "listeners_ids" {
  description = "Identifiers of the Listeners"
  value       = { for k, v in aws_lb_listener.this : k => v.id }
}

output "listeners_arns" {
  description = "ARNs of the Listeners"
  value       = { for k, v in aws_lb_listener.this : k => v.arn }
}
