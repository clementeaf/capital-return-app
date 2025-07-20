# S3 Bucket para el frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.project_name}-${var.environment}-frontend"
}

# Configuración de acceso público para el bucket del frontend
resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configuración de website para S3
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Política de bucket para acceso público (solo lectura)
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.frontend_bucket.bucket}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled    = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100" # Solo Norteamérica y Europa

  # Configuración de cache
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.frontend_bucket.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Configuración para SPA (Single Page Application)
  custom_error_response {
    error_code         = 404
    response_code      = "200"
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = "200"
    response_page_path = "/index.html"
  }

  # Configuración de logs (comentado por problemas de ACL)
  # logging_config {
  #   include_cookies = false
  #   bucket          = aws_s3_bucket.app_bucket.bucket_domain_name
  #   prefix          = "cloudfront-logs/"
  # }

  # Configuración de seguridad
  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version      = "TLSv1.2_2021"
  }

  # Configuración de restricciones geográficas
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend"
    Environment = var.environment
  }
}

# Outputs para el frontend
output "frontend_bucket_name" {
  description = "Nombre del bucket S3 del frontend"
  value       = aws_s3_bucket.frontend_bucket.bucket
}

output "frontend_website_endpoint" {
  description = "Endpoint del website S3"
  value       = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}

output "frontend_cloudfront_url" {
  description = "URL de CloudFront para el frontend"
  value       = "https://${aws_cloudfront_distribution.frontend_distribution.domain_name}"
}

output "frontend_deployment_instructions" {
  description = "Instrucciones para desplegar el frontend"
  value = <<-EOT
    Para desplegar el frontend:
    
    1. Construir el proyecto:
       cd ../frontend && npm run build
    
    2. Subir archivos a S3:
       aws s3 sync dist/ s3://${aws_s3_bucket.frontend_bucket.bucket} --delete
    
    3. Invalidar cache de CloudFront:
       aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.frontend_distribution.id} --paths "/*"
    
    4. URL del frontend: https://${aws_cloudfront_distribution.frontend_distribution.domain_name}
  EOT
} 