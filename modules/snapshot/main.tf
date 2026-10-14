resource "hcloud_storage_box_snapshot" "current" {
  storage_box_id = var.storage_box_id
  description    = var.description
  labels         = var.labels
}
