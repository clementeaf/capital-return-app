# Configuración simple del frontend - Solo S3 Website
# Más rápido y económico para desarrollo

# S3 Bucket para el frontend
resource "aws_s3_bucket" "frontend_bucket_simple" {
  bucket = "${var.project_name}-${var.environment}-frontend-simple"
}

# Configuración de acceso público para el bucket del frontend
resource "aws_s3_bucket_public_access_block" "frontend_bucket_simple_public_access" {
  bucket = aws_s3_bucket.frontend_bucket_simple.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configuración de website para S3
resource "aws_s3_bucket_website_configuration" "frontend_website_simple" {
  bucket = aws_s3_bucket.frontend_bucket_simple.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Política de bucket para acceso público (solo lectura)
resource "aws_s3_bucket_policy" "frontend_bucket_simple_policy" {
  bucket = aws_s3_bucket.frontend_bucket_simple.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket_simple.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket_simple_public_access]
}

# Outputs para el frontend simple
output "frontend_simple_bucket_name" {
  description = "Nombre del bucket S3 del frontend (simple)"
  value       = aws_s3_bucket.frontend_bucket_simple.bucket
}

output "frontend_simple_website_url" {
  description = "URL del website S3 (simple)"
  value       = "http://${aws_s3_bucket_website_configuration.frontend_website_simple.website_endpoint}"
}

output "frontend_simple_deployment_instructions" {
  description = "Instrucciones para desplegar el frontend (simple)"
  value = <<-EOT
    Para desplegar el frontend (versión simple):
    
    1. Construir el proyecto:
       cd ../frontend && npm run build
    
    2. Subir archivos a S3:
       aws s3 sync dist/ s3://${aws_s3_bucket.frontend_bucket_simple.bucket} --delete
    
    3. URL del frontend: http://${aws_s3_bucket_website_configuration.frontend_website_simple.website_endpoint}
    
    ⚡ Esta versión es más rápida de desplegar y más económica!
  EOT
} 