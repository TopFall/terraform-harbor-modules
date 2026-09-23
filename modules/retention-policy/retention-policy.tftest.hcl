mock_provider "harbor" {
  override_data {
    target = data.harbor_project.projects
    values = { id = "/projects/3" }
  }
}

run "applies_retention_policies" {
  command = plan

  variables {
    policies = {
      app = {
        schedule = "daily"
        rules = [
          { most_recently_pulled = 10, tag_matching = "**" },
          { n_days_since_last_push = 30, repo_matching = "release/**", tag_excluding = "latest" },
        ]
      }
      libs = {
        rules = [{ untagged_artifacts = true }]
      }
    }
  }

  assert {
    condition     = length(harbor_retention_policy.policies) == 2
    error_message = "expected two retention policies"
  }

  assert {
    condition     = harbor_retention_policy.policies["app"].scope == "/projects/3" && harbor_retention_policy.policies["libs"].scope == "/projects/3"
    error_message = "scope must reference the project id from the harbor_project data source"
  }

  assert {
    condition     = harbor_retention_policy.policies["app"].schedule == "daily"
    error_message = "schedule must be passed through"
  }

  assert {
    condition     = length(harbor_retention_policy.policies["app"].rule) == 2 && length(harbor_retention_policy.policies["libs"].rule) == 1
    error_message = "rule blocks must be expanded per policy"
  }

  assert {
    condition     = harbor_retention_policy.policies["app"].rule[0].most_recently_pulled == 10 && harbor_retention_policy.policies["app"].rule[1].tag_excluding == "latest"
    error_message = "rule attributes must be passed through"
  }
}
