variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "analytics_region" {
  description = "Region for Apigee analytics"
  type        = string
}

variable "organization_display_name" {
  description = "Display name for the organization"
  type        = string
  default     = "My Organization"
}

variable "organization_description" {
  description = "Description for the organization"
  type        = string
  default     = "My Organization"
}

variable "runtime_type" {
  description = "Runtime type for Apigee"
  type        = string
  default     = "HYBRID"
}

variable "envgroups" {
  description = "Mapping of environment groups"
  type        = map(list(string))
}

variable "environments" {
  description = "Mapping of environments"
  type        = map(object({
    display_name = string
    description  = string
    envgroups    = list(string)
  }))
}
