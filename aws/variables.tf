variable "allowed_ips_application" {
  description = "List of IP addresses allowed to access application on port 4000 of public IP. Default is all IPs."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "availability_zone" {
  description = "The availability zone to use."
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "Instance type to use. Default is 8x32."
  type        = string
  default     = "t3.2xlarge"
}

variable "login_email" {
  description = "The e-mail address to use for logging into the OpenCTI instance."
  type        = string
  default     = "login.email@example.com"
}

variable "region" {
  description = "The region to deploy in."
  type        = string
  default     = "us-east-1"
}

variable "root_volume_size" {
  description = "The size of the root volume."
  type        = number
  default     = 32
}

variable "storage_bucket" {
  description = "The name of the S3 storage bucket to store scripts and remote state in."
  type        = string
  default     = "opencti-storage"
}

variable "subnet_id" {
  description = "The subnet ID to use."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to use."
  type        = string
}
