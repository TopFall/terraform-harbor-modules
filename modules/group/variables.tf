variable "groups" {
  description = "List of Harbor groups and their project memberships. `type` is the Harbor group type (0 = LDAP, 1 = HTTP, 2 = OIDC); the membership `type` is the same value as a string (ldap, http, oidc). `role` accepts Harbor project roles (projectadmin, maintainer, developer, guest, limitedguest)."
  type = list(object({
    name = string
    type = number
    projects = optional(list(object({
      name = string
      role = string
      type = string
    })), [])
  }))

  validation {
    condition     = length(distinct([for group in var.groups : group.name])) == length(var.groups)
    error_message = "group names must be unique"
  }
}
