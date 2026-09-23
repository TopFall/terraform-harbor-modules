# Only non-sensitive attributes are exposed; robot account secrets are
# available through the dedicated `secrets` output.
output "robot_accounts" {
  description = "Map of Harbor robot accounts keyed by account name (without secrets)."
  value = {
    for name, account in harbor_robot_account.accounts : name => {
      id          = account.id
      robot_id    = account.robot_id
      full_name   = account.full_name
      level       = account.level
      description = account.description
      disabled    = account.disable
      duration    = account.duration
    }
  }
}

output "secrets" {
  description = "Map of robot account secrets keyed by account name."
  value       = { for name, account in harbor_robot_account.accounts : name => account.secret }
  sensitive   = true
}

output "robot_ids" {
  description = "Map of Harbor robot IDs keyed by account name."
  value       = { for name, account in harbor_robot_account.accounts : name => account.robot_id }
}
