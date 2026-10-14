variable "storage_box_id" {
  description = "ID of the source Storage Box. Changing this replaces the snapshot."
  type        = number
}

variable "description" {
  description = "Description of the snapshot. Null uses the provider default."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels attached to the snapshot."
  type        = map(string)
  default     = {}
  nullable    = false
}
