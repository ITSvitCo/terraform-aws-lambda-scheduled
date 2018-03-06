variable "namespace" {}

variable "stage" {}

variable "name" {}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "runtime" {}

variable "lambda_zipfile" {}

variable "source_code_hash" {}

variable "handler" {}

variable "schedule_expression" {}

variable "iam_policy_document" {}

variable "enabled" {
  default = true
}

variable "timeout" {
  default = 3
}
