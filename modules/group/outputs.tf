output "groups" {
  description = "Map of Harbor groups keyed by group name."
  value       = harbor_group.groups
}

output "memberships" {
  description = "Map of Harbor project member groups keyed by `<group_name>-<project_name>`."
  value       = harbor_project_member_group.members
}
