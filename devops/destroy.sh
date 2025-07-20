#!/bin/bash

# Script para destruir la infraestructura de Capital Return App
# Elimina todos los recursos de AWS creados por Terraform

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

echo -e "${RED}⚠️  ADVERTENCIA: Esto eliminará TODA la infraestructura de AWS${NC}"
echo -e "${YELLOW}Proyecto: ${PROJECT_NAME}${NC}"
echo -e "${YELLOW}Ambiente: ${ENVIRONMENT}${NC}"
echo -e "${YELLOW}Región: ${AWS_REGION}${NC}"

# Confirmar destrucción
echo -e "${RED}¿Estás seguro de que quieres eliminar toda la infraestructura? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}🗑️  Iniciando destrucción de infraestructura...${NC}"
    
    # Destruir infraestructura
    terraform destroy \
        -var="environment=${ENVIRONMENT}" \
        -var="aws_region=${AWS_REGION}" \
        -var="project_name=${PROJECT_NAME}" \
        -auto-approve
    
    echo -e "${GREEN}✅ Infraestructura eliminada exitosamente${NC}"
    
    # Limpiar archivos locales
    echo -e "${YELLOW}🧹 Limpiando archivos locales...${NC}"
    rm -f lambda_function.zip
    rm -rf .terraform
    rm -f .terraform.lock.hcl
    
    echo -e "${GREEN}✅ Limpieza completada${NC}"
    
else
    echo -e "${YELLOW}❌ Destrucción cancelada${NC}"
    exit 0
fi 