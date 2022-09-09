variable "project" {
  
}

variable "credentials_file" {
  
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
    default = "us-central1-c"
  
}

variable "vpc_name" {
  type        = string
  default     = "vpc-network-team"
  description = "desired name of the vpc being created"
}