mock_provider "harbor" {
  override_resource {
    target = harbor_robot_account.accounts

    values = {
      robot_id = "robot$test"
      secret   = "mock-secret"
    }

    override_during = plan
  }
}

run "creates_robot_accounts" {
  command = plan

  variables {
    robot_accounts = [
      {
        name        = "ci-push"
        level       = "project"
        description = "CI push account"
        permissions = [
          {
            kind      = "project"
            namespace = "app"
            access = [
              { action = "push", resource = "repository" },
              { action = "pull", resource = "repository" },
            ]
          },
        ]
      },
      {
        name        = "replication"
        level       = "system"
        description = "System replication account"
        permissions = [
          {
            kind      = "system"
            namespace = "/"
            access    = [{ action = "pull", resource = "repository", effect = "allow" }]
          },
        ]
        duration = 30
      },
    ]
  }

  assert {
    condition     = length(harbor_robot_account.accounts) == 2
    error_message = "expected two robot accounts"
  }

  assert {
    condition     = [for p in harbor_robot_account.accounts["ci-push"].permissions : length(p.access)] == [2]
    error_message = "access entries must be expanded per permission"
  }

  assert {
    condition     = harbor_robot_account.accounts["replication"].duration == 30
    error_message = "duration must be passed through"
  }

  assert {
    condition     = contains([for p in harbor_robot_account.accounts["replication"].permissions : one([for a in p.access : a.effect])], "allow")
    error_message = "optional effect must be passed through"
  }

  assert {
    condition     = harbor_robot_account.accounts["ci-push"].robot_id == "robot$test"
    error_message = "robot_id must come from the provider"
  }
}

run "outputs_generated_secrets" {
  command = plan

  variables {
    robot_accounts = [
      {
        name        = "ci-push"
        level       = "project"
        description = "CI push account"
        permissions = [
          {
            kind      = "project"
            namespace = "app"
            access    = [{ action = "push", resource = "repository" }]
          },
        ]
      },
    ]
  }

  assert {
    condition     = harbor_robot_account.accounts["ci-push"].secret == "mock-secret"
    error_message = "secret must come from the provider"
  }
}

run "fails_on_duplicate_names" {
  command = plan

  variables {
    robot_accounts = [
      {
        name        = "dup"
        level       = "project"
        description = "first"
        permissions = [
          { kind = "project", namespace = "app", access = [{ action = "pull", resource = "repository" }] },
        ]
      },
      {
        name        = "dup"
        level       = "project"
        description = "second"
        permissions = [
          { kind = "project", namespace = "libs", access = [{ action = "pull", resource = "repository" }] },
        ]
      },
    ]
  }

  expect_failures = [var.robot_accounts]
}

run "fails_on_invalid_level" {
  command = plan

  variables {
    robot_accounts = [
      {
        name        = "galaxy-bot"
        level       = "galaxy"
        description = "invalid level"
        permissions = [
          { kind = "project", namespace = "app", access = [{ action = "pull", resource = "repository" }] },
        ]
      },
    ]
  }

  expect_failures = [var.robot_accounts]
}
