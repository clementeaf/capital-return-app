#!/bin/bash

# Script para desplegar el frontend a S3 + CloudFront
# Capital Return App

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PROJECT_NAME="capital-return-app"
ENVIRONMENT=${1:-"dev"}
AWS_REGION=${2:-"us-east-1"}

echo -e "${GREEN}🚀 Desplegando frontend de Capital Return App${NC}"
echo -e "${YELLOW}Ambiente: ${ENVIRONMENT}${NC}"
echo -e "${YELLOW}Región: ${AWS_REGION}${NC}"

# Verificar que AWS CLI esté configurado
echo -e "${YELLOW}Verificando configuración de AWS CLI...${NC}"
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: AWS CLI no está configurado correctamente${NC}"
    echo "Ejecuta: aws configure"
    exit 1
fi

echo -e "${GREEN}✅ AWS CLI configurado correctamente${NC}"

# Navegar al directorio frontend
echo -e "${YELLOW}📁 Navegando al directorio frontend...${NC}"
cd ../frontend

# Verificar que node_modules existe
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Instalando dependencias...${NC}"
    npm install
fi

# Construir el proyecto
echo -e "${YELLOW}🔨 Construyendo el proyecto...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error en la construcción del proyecto${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Proyecto construido exitosamente${NC}"

# Obtener el nombre del bucket desde Terraform
echo -e "${YELLOW}📋 Obteniendo información de la infraestructura...${NC}"
cd ../devops

BUCKET_NAME=$(terraform output -raw frontend_bucket_name 2>/dev/null || echo "${PROJECT_NAME}-${ENVIRONMENT}-frontend")
DISTRIBUTION_ID=$(terraform output -raw frontend_cloudfront_distribution_id 2>/dev/null || echo "")

echo -e "${BLUE}📦 Bucket S3: ${BUCKET_NAME}${NC}"

# Subir archivos a S3
echo -e "${YELLOW}📤 Subiendo archivos a S3...${NC}"
aws s3 sync ../frontend/dist/ s3://${BUCKET_NAME} --delete

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error subiendo archivos a S3${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Archivos subidos exitosamente${NC}"

# Invalidar cache de CloudFront si existe
if [ ! -z "$DISTRIBUTION_ID" ]; then
    echo -e "${YELLOW}🔄 Invalidando cache de CloudFront...${NC}"
    aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths "/*"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Cache invalidado exitosamente${NC}"
    else
        echo -e "${YELLOW}⚠️  No se pudo invalidar el cache de CloudFront${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No se encontró ID de distribución de CloudFront${NC}"
fi

# Mostrar URLs
echo -e "${GREEN}🎉 Despliegue completado exitosamente!${NC}"
echo -e "${BLUE}📊 URLs del proyecto:${NC}"
echo -e "${BLUE}   Frontend: https://${BUCKET_NAME}.s3-website-${AWS_REGION}.amazonaws.com${NC}"
if [ ! -z "$DISTRIBUTION_ID" ]; then
    CLOUDFRONT_URL=$(terraform output -raw frontend_cloudfront_url 2>/dev/null || echo "")
    if [ ! -z "$CLOUDFRONT_URL" ]; then
        echo -e "${BLUE}   CloudFront: ${CLOUDFRONT_URL}${NC}"
    fi
fi
echo -e "${BLUE}   API: https://ghr2gobdi1.execute-api.${AWS_REGION}.amazonaws.com/${ENVIRONMENT}${NC}"

echo -e "${YELLOW}📝 Nota: Los cambios en CloudFront pueden tardar hasta 15 minutos en propagarse${NC}" 