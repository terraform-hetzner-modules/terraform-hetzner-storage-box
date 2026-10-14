output "server" {
  description = "Storage Box FQDN."
  value       = module.storage_box.server
}

output "username" {
  description = "Primary Storage Box username."
  value       = module.storage_box.username
}
