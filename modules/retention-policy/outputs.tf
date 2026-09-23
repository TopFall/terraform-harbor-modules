output "policies" {
  description = "Map of Harbor retention policies keyed by project name."
  value       = harbor_retention_policy.policies
}
