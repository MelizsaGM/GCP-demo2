variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  default     = "gcpdemo-task1"
}

variable "dbuser" {
  description = "The name of the default user"
  type        = string
  default     = "db-demo-user"
}


variable "image" {
  description = "Docker image"
  type        = string
  default     = "us.gcr.io/gcpdemo-task1/cronsql@sha256:9b9b076db233357649eab03035652b086d6c323f97a1e3b2814580b4730ed33b"
}
