variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  default     = "gcpdemo-task1"
}

variable "dbuser" {
  description = "The name of the default user"
  type        = string
  default     = "db-demo-user"
}
/*
variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}*/