variable "users" {
  description = "List of Harbor users and their project memberships. `role` accepts Harbor project roles (projectadmin, maintainer, developer, guest, limitedguest)."
  type = list(object({
    name = string
    projects = list(object({
      name = string
      role = string
    }))
  }))

  validation {
    condition     = length(distinct([for user in var.users : user.name])) == length(var.users)
    error_message = "user names must be unique"
  }
}
