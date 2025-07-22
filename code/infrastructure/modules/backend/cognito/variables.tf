variable "username" {
  description = "The initial name to use"
  type = string
}

variable "email" {
  description = "The email of the user"
  type = string
}

variable "region" {
  description = "The region we are deploying to"
  default = "us-east-1"
}