variable "region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "aws_availability_zone" {
  # Assign a number to each AZ letter used in our configuration
  default = "ap-northeast-1a"  
}

variable "region_number" {
  description = "AWS region"
  default     = {
  ap-northeast-1 = 1
 }
}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1    
  }
}

variable "vpc" {
  type    = string
  default = "Default Tokyo Virtual Private Cloud"
}