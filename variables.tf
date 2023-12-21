variable "region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "vpc" {
  type    = string
  default = "Default Tokyo Virtual Private Cloud"
}