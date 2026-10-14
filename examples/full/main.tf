module "storage_box" {
  source            = "../.."
  name              = "production-backups"
  type              = "bx21"
  location          = "hel1"
  password          = var.password
  delete_protection = true
  labels            = { environment = "production", managed_by = "terraform" }
  ssh_keys          = var.ssh_keys
  access_settings = {
    reachable_externally = true
    ssh_enabled          = true
    samba_enabled        = false
    webdav_enabled       = false
    zfs_enabled          = true
  }
  snapshot_plan = { max_snapshots = 10, hour = 2, minute = 30 }
  subaccounts = {
    backups = {
      home_directory  = "backups"
      password        = var.subaccount_passwords["backups"]
      description     = "Backup writer"
      labels          = { role = "writer" }
      access_settings = { ssh_enabled = true, reachable_externally = true, readonly = false }
    }
    reader = {
      name            = "backup-auditor"
      home_directory  = "backups"
      password        = var.subaccount_passwords["reader"]
      labels          = { role = "auditor" }
      access_settings = { ssh_enabled = true, reachable_externally = true, readonly = true }
    }
  }
}

module "snapshot" {
  source         = "../../modules/snapshot"
  storage_box_id = module.storage_box.id
  description    = "Initial configured box"
  labels         = { purpose = "initial" }
  depends_on     = [module.storage_box]
}
