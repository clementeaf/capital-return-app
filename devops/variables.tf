variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto para nombrar los recursos"
  type        = string
  default     = "capital-return-app"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod."
  }
}

variable "lambda_timeout" {
  description = "Timeout de la función Lambda en segundos"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memoria asignada a la función Lambda en MB"
  type        = number
  default     = 512
}

variable "dynamodb_billing_mode" {
  description = "Modo de facturación de DynamoDB"
  type        = string
  default     = "PAY_PER_REQUEST"
  
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.dynamodb_billing_mode)
    error_message = "El modo de facturación debe ser PAY_PER_REQUEST o PROVISIONED."
  }
}

variable "s3_bucket_versioning" {
  description = "Habilitar versionado en el bucket S3"
  type        = bool
  default     = true
}

variable "cloudwatch_log_retention" {
  description = "Días de retención de logs en CloudWatch"
  type        = number
  default     = 14
} 