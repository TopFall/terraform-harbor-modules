variable "robot_accounts" {
  description = "List of Harbor robot accounts to manage. `level` is either `system` or `project`; `duration` is the account lifetime in days (-1 means never expires); `secret` can be set to reuse an existing secret instead of letting Harbor generate one."
  type = list(object({
    name        = string
    level       = string
    description = string
    permissions = list(object({
      kind      = string
      namespace = string
      access = list(object({
        action   = string
        resource = string
        effect   = optional(string)
      }))
    }))
    # Optional
    disabled = optional(bool, false)
    duration = optional(number, -1)
    secret   = optional(string)
  }))

  validation {
    condition     = length(distinct([for account in var.robot_accounts : account.name])) == length(var.robot_accounts)
    error_message = "robot account names must be unique"
  }

  validation {
    condition     = alltrue([for account in var.robot_accounts : contains(["project", "system"], account.level)])
    error_message = "robot account level must be either \"project\" or \"system\""
  }
}
