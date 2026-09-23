output "projects" {
  description = "Map of Harbor projects keyed by project name."
  value       = harbor_project.projects
}

output "project_ids" {
  description = "Map of Harbor project IDs keyed by project name."
  value       = { for name, project in harbor_project.projects : name => project.id }
}
