variable "dynamodb_table_arn" {
  description = "The dynamodb tabe arn"
  type = string
}

variable "environemnt" {
  description = "The environment to deploy to."
  type = string
}

variable "region" {
  description = "The region we are using to deploy to."
  default = "us-east-1"
}