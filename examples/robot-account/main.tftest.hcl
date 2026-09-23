mock_provider "harbor" {
  override_resource {
    target = module.robot_accounts.harbor_robot_account.accounts

    values = {
      robot_id = "robot$ci-push"
      secret   = "generated-secret"
    }

    override_during = plan
  }
}

run "outputs_robot_accounts" {
  command = plan

  assert {
    condition     = module.robot_accounts.robot_ids["ci-push"] == "robot$ci-push"
    error_message = "robot_ids output must expose robot ids keyed by name"
  }

  assert {
    condition     = module.robot_accounts.secrets["ci-push"] == "generated-secret"
    error_message = "secrets output must expose generated secrets keyed by name"
  }

  assert {
    condition     = length(module.robot_accounts.robot_accounts) == 1 && module.robot_accounts.robot_accounts["ci-push"].duration == 30
    error_message = "robot_accounts output must expose non-sensitive attributes"
  }
}
