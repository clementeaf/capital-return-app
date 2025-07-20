#!/bin/bash

# Script de despliegue para Capital Return App
# Despliega la infraestructura en AWS usando Terraform

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
PROJECT_NAME="capital-return-app"
ENVIRONMENT=${1:-"dev"}
AWS_REGION=${2:-"us-east-1"}

echo -e "${GREEN}🚀 Iniciando despliegue de Capital Return App${NC}"
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

# Verificar que Terraform esté instalado
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}❌ Error: Terraform no está instalado${NC}"
    echo "Instala Terraform desde: https://www.terraform.io/downloads.html"
    exit 1
fi

echo -e "${GREEN}✅ Terraform encontrado${NC}"

# Crear archivo ZIP para Lambda
echo -e "${YELLOW}📦 Creando paquete para Lambda...${NC}"

# Crear directorio temporal
mkdir -p temp_lambda

# Copiar código Lambda
cp lambda_function.py temp_lambda/main.py

# Instalar dependencias en el directorio temporal
pip install -r requirements.txt -t temp_lambda/

# Crear ZIP
cd temp_lambda
zip -r ../lambda_function.zip .
cd ..

# Limpiar directorio temporal
rm -rf temp_lambda

echo -e "${GREEN}✅ Paquete Lambda creado: lambda_function.zip${NC}"

# Inicializar Terraform
echo -e "${YELLOW}🔧 Inicializando Terraform...${NC}"
terraform init

# Planificar despliegue
echo -e "${YELLOW}📋 Planificando despliegue...${NC}"
terraform plan \
    -var="environment=${ENVIRONMENT}" \
    -var="aws_region=${AWS_REGION}" \
    -var="project_name=${PROJECT_NAME}"

# Confirmar despliegue
echo -e "${YELLOW}¿Continuar con el despliegue? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${GREEN}🚀 Iniciando despliegue...${NC}"
    
    # Aplicar configuración
    terraform apply \
        -var="environment=${ENVIRONMENT}" \
        -var="aws_region=${AWS_REGION}" \
        -var="project_name=${PROJECT_NAME}" \
        -auto-approve
    
    echo -e "${GREEN}✅ Despliegue completado exitosamente!${NC}"
    
    # Mostrar outputs
    echo -e "${YELLOW}📊 Información del despliegue:${NC}"
    terraform output
    
    # Mostrar URL de la API
    API_URL=$(terraform output -raw api_gateway_invoke_url)
    echo -e "${GREEN}🌐 URL de la API: ${API_URL}${NC}"
    echo -e "${GREEN}📝 Documentación: ${API_URL}/docs${NC}"
    
else
    echo -e "${YELLOW}❌ Despliegue cancelado${NC}"
    exit 0
fi 