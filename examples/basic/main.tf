module "storage_box" {
  source   = "../.."
  name     = "backups"
  type     = "bx21"
  password = var.password
}
