mock_provider "harbor" {
  override_data {
    target = data.harbor_project.projects
    values = { id = "/projects/5" }
  }
}

run "creates_user_memberships" {
  command = plan

  variables {
    users = [
      {
        name = "alice"
        projects = [
          { name = "app", role = "developer" },
          { name = "libs", role = "guest" },
        ]
      },
      {
        name     = "bob"
        projects = [{ name = "app", role = "limitedguest" }]
      },
    ]
  }

  assert {
    condition     = length(harbor_project_member_user.members) == 3
    error_message = "expected three user memberships"
  }

  assert {
    condition     = harbor_project_member_user.members["alice-libs"].project_id == "/projects/5"
    error_message = "project_id must be resolved from the harbor_project data source"
  }

  assert {
    condition     = harbor_project_member_user.members["bob-app"].user_name == "bob" && harbor_project_member_user.members["bob-app"].role == "limitedguest"
    error_message = "membership must map user name and role"
  }
}

run "fails_on_duplicate_users" {
  command = plan

  variables {
    users = [
      { name = "alice", projects = [{ name = "app", role = "developer" }] },
      { name = "alice", projects = [{ name = "libs", role = "guest" }] },
    ]
  }

  expect_failures = [var.users]
}
