variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subnets privadas"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks permitidos para acceder a Aurora"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}

variable "master_username" {
  description = "Usuario maestro para Aurora"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Contraseña maestra para Aurora"
  type        = string
}

variable "database_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "availability_zones" {
  description = "Zonas de disponibilidad para Multi-AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_class" {
  description = "Clase de instancia de Aurora"
  type        = string
  default     = "db.r5.large"
}

variable "instance_count" {
  description = "Número de instancias en el clúster"
  type        = number
  default     = 2
}
