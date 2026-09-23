locals {
  project_memberships = {
    for membership in flatten([
      for user in var.users : [
        for project in user.projects : {
          key          = "${user.name}-${project.name}"
          user_name    = user.name
          role         = project.role
          project_name = project.name
        }
      ]
    ]) : membership.key => membership
  }
}

data "harbor_project" "projects" {
  for_each = local.project_memberships
  name     = each.value.project_name
}

resource "harbor_project_member_user" "members" {
  for_each   = data.harbor_project.projects
  project_id = each.value.id
  user_name  = local.project_memberships[each.key].user_name
  role       = local.project_memberships[each.key].role
}
