output "id" {
  description = "Snapshot id."
  value       = hcloud_storage_box_snapshot.current.id
}

output "storage_box_id" {
  description = "Snapshot storage box id."
  value       = hcloud_storage_box_snapshot.current.storage_box_id
}

output "description" {
  description = "Snapshot description."
  value       = hcloud_storage_box_snapshot.current.description
}

output "labels" {
  description = "Snapshot labels."
  value       = hcloud_storage_box_snapshot.current.labels
}

output "name" {
  description = "Snapshot name."
  value       = hcloud_storage_box_snapshot.current.name
}

output "is_automatic" {
  description = "Snapshot is automatic."
  value       = hcloud_storage_box_snapshot.current.is_automatic
}
