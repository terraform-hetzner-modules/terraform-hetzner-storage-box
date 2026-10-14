variable "password" {
  description = "Primary Storage Box password."
  type        = string
  sensitive   = true
}

variable "subaccount_passwords" {
  description = "Passwords for the backups and reader subaccounts."
  type        = map(string)
  sensitive   = true
}

variable "ssh_keys" {
  description = "Initial SSH public key contents. Changing these replaces the Storage Box."
  type        = set(string)
  default     = []
}
