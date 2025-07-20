#!/bin/bash

# Script de despliegue RÁPIDO del frontend - Solo S3
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

echo -e "${GREEN}⚡ Despliegue RÁPIDO del frontend${NC}"
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

BUCKET_NAME=$(terraform output -raw frontend_simple_bucket_name 2>/dev/null || echo "${PROJECT_NAME}-${ENVIRONMENT}-frontend-simple")

echo -e "${BLUE}📦 Bucket S3: ${BUCKET_NAME}${NC}"

# Subir archivos a S3
echo -e "${YELLOW}📤 Subiendo archivos a S3...${NC}"
aws s3 sync ../frontend/dist/ s3://${BUCKET_NAME} --delete

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error subiendo archivos a S3${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Archivos subidos exitosamente${NC}"

# Mostrar URLs
echo -e "${GREEN}🎉 Despliegue RÁPIDO completado!${NC}"
echo -e "${BLUE}📊 URLs del proyecto:${NC}"
echo -e "${BLUE}   Frontend: http://${BUCKET_NAME}.s3-website-${AWS_REGION}.amazonaws.com${NC}"
echo -e "${BLUE}   API: https://ghr2gobdi1.execute-api.${AWS_REGION}.amazonaws.com/${ENVIRONMENT}${NC}"

echo -e "${GREEN}⚡ ¡Listo! El frontend está disponible inmediatamente${NC}" 