variable "credentials" {
  description = "Path to the service account key file."
  type        = string
}

variable "disk_size" {
  description = "The disk size (in GB) for the instance."
  type        = number
  default     = 32
}

variable "login_email" {
  description = "The email used to login to the OpenCTI web page."
  type        = string
  default     = "login.email@example.com"
}

variable "machine_type" {
  description = "The machine type to use."
  type        = string
  default     = "e2-standard-8"
}

variable "project_id" {
  description = "The project ID string for the GCP project."
  type        = string
}

variable "region" {
  description = "The Google Cloud region to run the instance in."
  type        = string
  default     = "us-east1"
}

variable "storage_bucket" {
  description = "Name of the storage bucket."
  type        = string
  default     = "opencti-storage"
}

variable "zone" {
  description = "The Google Cloud zone to run the instance in."
  type        = string
  default     = "us-east1-b"
}
