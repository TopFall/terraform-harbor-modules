data "harbor_project" "projects" {
  for_each = var.policies
  name     = each.key
}

resource "harbor_retention_policy" "policies" {
  for_each = var.policies

  scope    = data.harbor_project.projects[each.key].id
  schedule = each.value.schedule

  dynamic "rule" {
    for_each = each.value.rules
    content {
      always_retain          = rule.value.always_retain
      disabled               = rule.value.disabled
      most_recently_pulled   = rule.value.most_recently_pulled
      most_recently_pushed   = rule.value.most_recently_pushed
      n_days_since_last_pull = rule.value.n_days_since_last_pull
      n_days_since_last_push = rule.value.n_days_since_last_push
      repo_excluding         = rule.value.repo_excluding
      repo_matching          = rule.value.repo_matching
      tag_excluding          = rule.value.tag_excluding
      tag_matching           = rule.value.tag_matching
      untagged_artifacts     = rule.value.untagged_artifacts
    }
  }
}
