variable "name" {
  description = "Name of the Storage Box."
  type        = string
}

variable "type" {
  description = "Storage Box type, for example bx21."
  type        = string
}

variable "location" {
  description = "Storage Box location. Changing this replaces the box."
  type        = string
  default     = "fsn1"
}

variable "password" {
  description = "Primary password, subject to Hetzner's Storage Box password policy. Stored in Terraform state."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "labels" {
  description = "Labels for the Storage Box and shared defaults for subaccounts. Subaccount labels take precedence."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "delete_protection" {
  description = "Protect against deletion outside Terraform. This does not prevent Terraform from destroying the box."
  type        = bool
  default     = true
  nullable    = false
}

variable "access_settings" {
  description = "Storage Box access settings. Null or omitted fields use provider defaults."
  type = object({
    reachable_externally = optional(bool)
    samba_enabled        = optional(bool)
    ssh_enabled          = optional(bool)
    webdav_enabled       = optional(bool)
    zfs_enabled          = optional(bool)
  })
  default = null
}

variable "snapshot_plan" {
  description = "Automatic snapshot schedule in UTC. Null disables the plan. day_of_week uses 0=Sunday through 6=Saturday; null day fields mean every day."
  type = object({
    max_snapshots = number
    hour          = number
    minute        = number
    day_of_week   = optional(number)
    day_of_month  = optional(number)
  })
  default = null
}

variable "ssh_keys" {
  description = "Initial SSH public key contents (not Cloud SSH key IDs). Changing these keys replaces the entire Storage Box. Null uses the provider default."
  type        = set(string)
  default     = null
}

variable "subaccounts" {
  description = "Subaccounts keyed by stable, non-secret identifiers. Names default to map keys. Passwords are sensitive and stored in state; only map keys are declassified for resource addresses."
  type = map(object({
    name           = optional(string)
    home_directory = string
    password       = string
    description    = optional(string)
    labels         = optional(map(string), {})
    access_settings = optional(object({
      reachable_externally = optional(bool)
      samba_enabled        = optional(bool)
      ssh_enabled          = optional(bool)
      webdav_enabled       = optional(bool)
      readonly             = optional(bool)
    }))
  }))
  default   = {}
  nullable  = false
  sensitive = true

  validation {
    condition     = alltrue([for account in values(var.subaccounts) : try(!startswith(account.home_directory, "/"), false)])
    error_message = "Subaccount home_directory must be relative, without a leading slash."
  }
}
