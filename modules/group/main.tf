locals {
  project_memberships = {
    for membership in flatten([
      for group in var.groups : [
        for project in group.projects : {
          key          = "${group.name}-${project.name}"
          group_name   = group.name
          role         = project.role
          type         = project.type
          project_name = project.name
        }
      ]
    ]) : membership.key => membership
  }
}

resource "harbor_group" "groups" {
  for_each = { for group in var.groups : group.name => group }

  group_name = each.key
  group_type = each.value.type
}

data "harbor_project" "projects" {
  for_each = local.project_memberships
  name     = each.value.project_name
}

resource "harbor_project_member_group" "members" {
  for_each   = data.harbor_project.projects
  project_id = each.value.id
  group_name = local.project_memberships[each.key].group_name
  role       = local.project_memberships[each.key].role
  type       = local.project_memberships[each.key].type
}
