module "users" {
  source = "../../modules/user"

  users = [
    {
      name = "alice"
      projects = [
        { name = "app", role = "developer" },
        { name = "libs", role = "guest" },
      ]
    },
  ]
}
