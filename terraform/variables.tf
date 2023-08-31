variable "aws_access_key" {
  description = "AWS access_key"
  sensitive   = true
}
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  sensitive   = false
}
variable "aws_secret_key" {
  description = "AWS secret_key"
  sensitive   = true
}
