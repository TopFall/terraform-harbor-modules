module "retention_policies" {
  source = "../../modules/retention-policy"

  policies = {
    app = {
      schedule = "daily"
      rules = [
        { most_recently_pulled = 10, tag_matching = "**" },
        { n_days_since_last_push = 30, repo_matching = "release/**" },
      ]
    }
    libs = {
      rules = [{ untagged_artifacts = true }]
    }
  }
}
