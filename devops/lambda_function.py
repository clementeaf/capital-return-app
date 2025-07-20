import json
import os
import boto3
from datetime import datetime
import logging

# Configurar logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Inicializar clientes AWS
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')

# Obtener variables de entorno
DYNAMODB_TABLE = os.environ.get('DYNAMODB_TABLE')
S3_BUCKET = os.environ.get('S3_BUCKET')
ENVIRONMENT = os.environ.get('ENVIRONMENT')

def handler(event, context):
    """
    Manejador principal de la función Lambda
    """
    try:
        # Obtener información de la petición
        http_method = event.get('httpMethod', 'GET')
        path = event.get('path', '/')
        
        logger.info(f"Procesando petición: {http_method} {path}")
        
        # Manejar diferentes rutas
        if path == '/' or path == '/health':
            return health_check()
        elif path == '/api/data':
            return handle_data_endpoint(event, http_method)
        elif path == '/api/files':
            return handle_files_endpoint(event, http_method)
        else:
            return create_response(404, {'error': 'Endpoint no encontrado'})
            
    except Exception as e:
        logger.error(f"Error en handler: {str(e)}")
        return create_response(500, {'error': 'Error interno del servidor'})

def health_check():
    """
    Endpoint de verificación de salud
    """
    return create_response(200, {
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat(),
        'environment': ENVIRONMENT,
        'services': {
            'dynamodb_table': DYNAMODB_TABLE,
            's3_bucket': S3_BUCKET
        }
    })

def handle_data_endpoint(event, http_method):
    """
    Maneja operaciones CRUD en DynamoDB
    """
    table = dynamodb.Table(DYNAMODB_TABLE)
    
    if http_method == 'GET':
        # Obtener todos los elementos
        try:
            response = table.scan()
            return create_response(200, {
                'data': response.get('Items', []),
                'count': response.get('Count', 0)
            })
        except Exception as e:
            logger.error(f"Error obteniendo datos: {str(e)}")
            return create_response(500, {'error': 'Error obteniendo datos'})
    
    elif http_method == 'POST':
        # Crear nuevo elemento
        try:
            body = json.loads(event.get('body', '{}'))
            item_id = f"item_{datetime.utcnow().timestamp()}"
            
            item = {
                'id': item_id,
                'data': body.get('data', {}),
                'created_at': datetime.utcnow().isoformat(),
                'updated_at': datetime.utcnow().isoformat()
            }
            
            table.put_item(Item=item)
            return create_response(201, {'message': 'Elemento creado', 'id': item_id})
            
        except Exception as e:
            logger.error(f"Error creando elemento: {str(e)}")
            return create_response(500, {'error': 'Error creando elemento'})
    
    else:
        return create_response(405, {'error': 'Método no permitido'})

def handle_files_endpoint(event, http_method):
    """
    Maneja operaciones de archivos en S3
    """
    if http_method == 'GET':
        # Listar archivos en S3
        try:
            response = s3.list_objects_v2(Bucket=S3_BUCKET)
            files = []
            
            if 'Contents' in response:
                for obj in response['Contents']:
                    files.append({
                        'key': obj['Key'],
                        'size': obj['Size'],
                        'last_modified': obj['LastModified'].isoformat()
                    })
            
            return create_response(200, {
                'files': files,
                'count': len(files)
            })
            
        except Exception as e:
            logger.error(f"Error listando archivos: {str(e)}")
            return create_response(500, {'error': 'Error listando archivos'})
    
    elif http_method == 'POST':
        # Subir archivo a S3 (simulado)
        try:
            body = json.loads(event.get('body', '{}'))
            file_name = body.get('file_name', f"file_{datetime.utcnow().timestamp()}")
            
            # En un caso real, aquí se procesaría el archivo
            # Por ahora solo simulamos la creación
            s3.put_object(
                Bucket=S3_BUCKET,
                Key=file_name,
                Body=json.dumps(body.get('content', '')),
                ContentType='application/json'
            )
            
            return create_response(201, {
                'message': 'Archivo subido exitosamente',
                'file_name': file_name
            })
            
        except Exception as e:
            logger.error(f"Error subiendo archivo: {str(e)}")
            return create_response(500, {'error': 'Error subiendo archivo'})
    
    else:
        return create_response(405, {'error': 'Método no permitido'})

def create_response(status_code, body):
    """
    Crea una respuesta HTTP estándar
    """
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS'
        },
        'body': json.dumps(body, ensure_ascii=False)
    } 