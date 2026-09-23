module "groups" {
  source = "../../modules/group"

  groups = [
    {
      name = "sre"
      type = 2 # OIDC
      projects = [
        { name = "app", role = "maintainer", type = "oidc" },
      ]
    },
    {
      name = "release"
      type = 0 # LDAP
      projects = [
        { name = "app", role = "guest", type = "ldap" },
      ]
    },
  ]
}
