output "memberships" {
  description = "Map of Harbor project member users keyed by `<user_name>-<project_name>`."
  value       = harbor_project_member_user.members
}
