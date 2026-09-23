mock_provider "harbor" {
  override_data {
    target = data.harbor_project.projects
    values = { id = "/projects/9" }
  }
}

run "creates_groups_and_memberships" {
  command = plan

  variables {
    groups = [
      {
        name = "sre"
        type = 2
        projects = [
          { name = "app", role = "maintainer", type = "oidc" },
        ]
      },
      {
        name = "readonly"
        type = 0
      },
    ]
  }

  assert {
    condition     = length(harbor_group.groups) == 2
    error_message = "expected two Harbor groups"
  }

  assert {
    condition     = harbor_group.groups["sre"].group_type == 2
    error_message = "group type must be passed through"
  }

  assert {
    condition     = length(harbor_project_member_group.members) == 1
    error_message = "groups without projects must not create memberships"
  }

  assert {
    condition     = harbor_project_member_group.members["sre-app"].project_id == "/projects/9" && harbor_project_member_group.members["sre-app"].group_name == "sre" && harbor_project_member_group.members["sre-app"].role == "maintainer" && harbor_project_member_group.members["sre-app"].type == "oidc"
    error_message = "membership must map group, role, type and project"
  }
}

run "fails_on_duplicate_groups" {
  command = plan

  variables {
    groups = [
      { name = "dup", type = 2, projects = [{ name = "app", role = "guest", type = "oidc" }] },
      { name = "dup", type = 0, projects = [{ name = "libs", role = "guest", type = "ldap" }] },
    ]
  }

  expect_failures = [var.groups]
}
