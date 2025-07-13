variable "project_name" {
  description = "Nombre del proyecto para etiquetar recursos"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block para la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de CIDR blocks para subnets públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de CIDR blocks para subnets privadas"
  type        = list(string)
}

variable "azs" {
  description = "Zonas de disponibilidad"
  type        = list(string)
}
