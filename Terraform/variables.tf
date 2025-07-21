variable "subnet_id" {
  description = "EC2 default subnet id"
  type        = string
  default     = "subnet-0fb155b4776b96c85"
}

variable "access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
