# DevOps - Capital Return App

Infraestructura como código (IaC) para desplegar la aplicación Capital Return App en AWS usando Terraform.

## Arquitectura

### Servicios AWS utilizados:
- **AWS Lambda** - Servidor sin servidor para la API
- **API Gateway** - Endpoint HTTP para la API
- **DynamoDB** - Base de datos NoSQL
- **S3** - Almacenamiento de archivos
- **CloudWatch** - Logs y monitoreo
- **IAM** - Roles y políticas de seguridad

### Diagrama de arquitectura:
```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Cliente   │───▶│ API Gateway  │───▶│   Lambda    │
└─────────────┘    └──────────────┘    └─────────────┘
                                              │
                                              ▼
                    ┌─────────────┐    ┌─────────────┐
                    │  DynamoDB   │    │     S3      │
                    └─────────────┘    └─────────────┘
```

## Prerrequisitos

### 1. AWS CLI
```bash
# Instalar AWS CLI
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Configurar AWS CLI
aws configure
```

### 2. Terraform
```bash
# Instalar Terraform (macOS)
brew install terraform

# Verificar instalación
terraform --version
```

### 3. Python (para dependencias Lambda)
```bash
# Verificar Python
python3 --version
pip3 --version
```

## Despliegue

### Despliegue automático (recomendado)
```bash
# Dar permisos de ejecución
chmod +x deploy.sh

# Desplegar en ambiente dev
./deploy.sh dev us-east-1

# Desplegar en ambiente staging
./deploy.sh staging us-east-1

# Desplegar en ambiente prod
./deploy.sh prod us-east-1
```

### Despliegue manual
```bash
# 1. Inicializar Terraform
terraform init

# 2. Planificar despliegue
terraform plan -var="environment=dev" -var="aws_region=us-east-1"

# 3. Aplicar configuración
terraform apply -var="environment=dev" -var="aws_region=us-east-1" -auto-approve
```

## Destrucción

### Destrucción automática
```bash
# Dar permisos de ejecución
chmod +x destroy.sh

# Destruir infraestructura
./destroy.sh dev us-east-1
```

### Destrucción manual
```bash
# Destruir infraestructura
terraform destroy -var="environment=dev" -var="aws_region=us-east-1" -auto-approve
```

## Endpoints de la API

Una vez desplegado, la API estará disponible en:
- **URL Base**: `https://[api-id].execute-api.[region].amazonaws.com/dev`
- **Health Check**: `GET /health`
- **Datos**: `GET/POST /api/data`
- **Archivos**: `GET/POST /api/files`

## Variables de configuración

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `aws_region` | Región de AWS | `us-east-1` |
| `project_name` | Nombre del proyecto | `capital-return-app` |
| `environment` | Ambiente (dev/staging/prod) | `dev` |
| `lambda_timeout` | Timeout de Lambda (segundos) | `30` |
| `lambda_memory_size` | Memoria de Lambda (MB) | `512` |

## Estructura de archivos

```
devops/
├── main.tf              # Configuración principal de Terraform
├── variables.tf         # Variables de configuración
├── outputs.tf          # Outputs de Terraform
├── lambda_function.py  # Código de la función Lambda
├── requirements.txt    # Dependencias de Python
├── deploy.sh          # Script de despliegue automático
├── destroy.sh         # Script de destrucción
└── README.md          # Este archivo
```

## Monitoreo y logs

### CloudWatch Logs
- **Grupo de logs**: `/aws/lambda/capital-return-app-dev-function`
- **Retención**: 14 días

### Métricas importantes
- Invocaciones de Lambda
- Duración de ejecución
- Errores de Lambda
- Latencia de API Gateway

## Costos estimados

### Ambiente de desarrollo (dev)
- **Lambda**: ~$0.50/mes (1000 invocaciones)
- **API Gateway**: ~$1.00/mes
- **DynamoDB**: ~$0.25/mes (PAY_PER_REQUEST)
- **S3**: ~$0.02/mes (1GB)
- **CloudWatch**: ~$0.50/mes

**Total estimado**: ~$2.27/mes

## Seguridad

### IAM Roles y Políticas
- **Principio de menor privilegio** aplicado
- **Políticas específicas** para cada servicio
- **Logs de auditoría** habilitados

### Configuraciones de seguridad
- **S3**: Acceso público bloqueado
- **DynamoDB**: Encriptación en reposo
- **Lambda**: Variables de entorno seguras
- **API Gateway**: CORS configurado

## Troubleshooting

### Problemas comunes

1. **Error de permisos AWS**
   ```bash
   aws sts get-caller-identity
   ```

2. **Error de Terraform**
   ```bash
   terraform init
   terraform validate
   ```

3. **Error de Lambda**
   ```bash
   aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/capital-return-app"
   ```

## Comandos útiles

```bash
# Ver estado de Terraform
terraform show

# Ver outputs
terraform output

# Ver logs de Lambda
aws logs tail /aws/lambda/capital-return-app-dev-function --follow

# Invocar Lambda localmente
aws lambda invoke --function-name capital-return-app-dev-function --payload '{"httpMethod":"GET","path":"/health"}' response.json
``` 