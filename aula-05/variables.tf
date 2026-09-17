variable "db_name" {
  type        = string
  default     = "technovadb"
  description = "Nome do banco de dados"
}

variable "db_username" {
  type        = string
  default     = "postgres"
  description = "Usuario mestre do RDS"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Senha do usuario mestre do RDS"
}
