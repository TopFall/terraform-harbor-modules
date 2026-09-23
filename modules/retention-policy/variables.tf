# Map of project names to their retention policy configurations.
# Each project can have its own unique policy settings.

variable "policies" {
  description = "Map of tag retention policies keyed by Harbor project name. `schedule` accepts Harbor schedule values (hourly, daily, weekly, or a cron expression). Every rule must select exactly one retention criterion (always_retain, most_recently_pulled, most_recently_pushed, n_days_since_last_pull, n_days_since_last_push or untagged_artifacts)."
  type = map(object({
    schedule = optional(string)
    rules = list(object({
      # Optional
      always_retain          = optional(bool)
      disabled               = optional(bool)
      most_recently_pulled   = optional(number)
      most_recently_pushed   = optional(number)
      n_days_since_last_pull = optional(number)
      n_days_since_last_push = optional(number)
      repo_excluding         = optional(string)
      repo_matching          = optional(string)
      tag_excluding          = optional(string)
      tag_matching           = optional(string)
      untagged_artifacts     = optional(bool)
    }))
  }))
  default = {}
}
