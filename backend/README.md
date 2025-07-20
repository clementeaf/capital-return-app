# Backend - Capital Return API

API REST construida con FastAPI para la gestión de retornos de capital.

## Instalación

1. Activar el entorno virtual:
```bash
source venv/bin/activate  # En macOS/Linux
# o
venv\Scripts\activate     # En Windows
```

2. Instalar dependencias:
```bash
pip install -r requirements.txt
```

## Ejecución

### Desarrollo
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Producción
```bash
python main.py
```

## Endpoints

- `GET /` - Mensaje de bienvenida
- `GET /health` - Verificación de salud de la API
- `GET /docs` - Documentación automática (Swagger UI)
- `GET /redoc` - Documentación alternativa (ReDoc)

## Estructura

```
backend/
├── main.py              # Archivo principal de la aplicación
├── requirements.txt     # Dependencias del proyecto
├── venv/               # Entorno virtual (no incluido en git)
└── README.md           # Este archivo
```

## Tecnologías

- **FastAPI**: Framework web moderno y rápido
- **Uvicorn**: Servidor ASGI
- **Pydantic**: Validación de datos 