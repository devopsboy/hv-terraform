variable "instance_name" {
  type = string
}

variable "create" {
  type = bool
}

variable "ami_id" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "user_data" {
  type = string
  nullable = true
}

variable "root_volume_size" {
  type = number
}