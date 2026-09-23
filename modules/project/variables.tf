variable "projects" {
  description = "List of Harbor projects to manage."
  type = list(object({
    name = string
    # Optional
    public                      = optional(bool, false)
    vulnerability_scanning      = optional(bool, false)
    enable_content_trust        = optional(bool, false)
    enable_content_trust_cosign = optional(bool, false)
    auto_sbom_generation        = optional(bool, false)
    cve_allowlist               = optional(list(string), [])
    deployment_security         = optional(string)
    force_destroy               = optional(bool, false)
    storage_quota               = optional(number, -1)
    proxy_registry_name         = optional(string)
  }))

  validation {
    condition     = length(distinct([for project in var.projects : project.name])) == length(var.projects)
    error_message = "project names must be unique"
  }
}

variable "available_registries" {
  description = "Map of Harbor registries used to resolve `proxy_registry_name`. Pass the `registries` output of the registry module."
  type        = map(any)
  default     = {}
}
