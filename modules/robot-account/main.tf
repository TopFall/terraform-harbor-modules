resource "harbor_robot_account" "accounts" {
  for_each = { for account in var.robot_accounts : account.name => account }

  level       = each.value.level
  name        = each.key
  description = each.value.description

  dynamic "permissions" {
    for_each = each.value.permissions
    content {
      kind      = permissions.value.kind
      namespace = permissions.value.namespace

      dynamic "access" {
        for_each = permissions.value.access
        content {
          action   = access.value.action
          resource = access.value.resource
          effect   = access.value.effect
        }
      }
    }
  }

  disable  = each.value.disabled
  duration = each.value.duration
  secret   = each.value.secret
}
