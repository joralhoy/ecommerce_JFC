variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "default_ttl" {
  description = "TTL por defecto para el contenido cacheado"
  type        = number
  default     = 86400  # 1 día
}

variable "max_ttl" {
  description = "TTL máximo para el contenido cacheado"
  type        = number
  default     = 31536000  # 1 año
}
