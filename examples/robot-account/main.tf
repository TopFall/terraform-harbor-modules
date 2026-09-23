module "robot_accounts" {
  source = "../../modules/robot-account"

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
            { action = "pull", resource = "repository" },
            { action = "push", resource = "repository" },
          ]
        },
      ]
      duration = 30
    },
  ]
}
