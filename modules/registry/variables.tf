variable "registries" {
  description = "List of external registries to register in Harbor. `provider_name` is one of the Harbor registry adapter types (dockerhub, harbor, azure-acr, aws-ecr, google-gcr, quay, gitlab, github-docker, jfrog-artifactory, etc.)."
  type = list(object({
    name          = string
    provider_name = string
    endpoint_url  = string
    # Optional
    description   = optional(string)
    access_id     = optional(string)
    access_secret = optional(string)
    insecure      = optional(bool, false)
  }))

  validation {
    condition     = length(distinct([for registry in var.registries : registry.name])) == length(var.registries)
    error_message = "registry names must be unique"
  }
}
