variable "project_name" {
  description = "Name prefix for resources"
  default     = "order-system"
}

variable "suffix" {
  description = "Unique identifier for each deployment (set by GitHub Actions)"
  type        = string
  default     = "local"
}
