output "api_gateway_url" {
  description = "URL del API Gateway"
  value       = "${aws_api_gateway_rest_api.app_api.execution_arn}${var.environment}"
}

output "api_gateway_invoke_url" {
  description = "URL de invocación del API Gateway"
  value       = "https://${aws_api_gateway_rest_api.app_api.id}.execute-api.${var.aws_region}.amazonaws.com/${var.environment}"
}

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.app_table.name
}

output "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.app_table.arn
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.app_bucket.bucket
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.app_bucket.arn
}

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.app_function.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.app_function.arn
}

output "lambda_role_arn" {
  description = "ARN del rol IAM de Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "cloudwatch_log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}

output "project_info" {
  description = "Información del proyecto"
  value = {
    project_name = var.project_name
    environment  = var.environment
    region       = var.aws_region
    deployment_time = timestamp()
  }
} 