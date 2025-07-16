variable "bucket_name" {
  description = "Имя S3 бакета"
  type        = string
}

variable "tags" {
  description = "Теги ресурса"
  type        = map(string)
  default     = {}
}
