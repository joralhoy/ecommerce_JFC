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

variable "desired_size" {
  description = "Número deseado de nodos en el grupo gestionado"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Número mínimo de nodos en el grupo gestionado"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Número máximo de nodos en el grupo gestionado"
  type        = number
  default     = 4
}

variable "instance_type" {
  description = "Tipo de instancia EC2 para los nodos del EKS"
  type        = string
  default     = "t3.medium"
}
