variable "ec2_instance_number" {
  type = number
}

variable "subnet_list" {
  type = list(string)
}

variable "user_data" {
  type = string
}