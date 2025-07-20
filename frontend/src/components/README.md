# Sistema de ErrorBoundary

Este directorio contiene el sistema completo de manejo de errores para la aplicación.

## Componentes

### ErrorBoundary.jsx
Componente principal que captura errores de React y muestra una UI de fallback.

**Características:**
- Captura errores de renderizado
- Muestra UI de fallback personalizada
- Logging de errores en consola
- Detalles del error en modo desarrollo
- Botones para recargar página o reintentar

### withErrorBoundary.jsx
HOC (Higher Order Component) para envolver componentes con ErrorBoundary fácilmente.

**Uso:**
```jsx
import withErrorBoundary from './components/withErrorBoundary'

const MyComponent = () => <div>Mi componente</div>
export default withErrorBoundary(MyComponent)
```

### ErrorProneComponent.jsx
Componente de ejemplo que puede generar errores para probar el ErrorBoundary.

## Hooks

### useErrorHandler.js
Hook personalizado para manejar errores de manera consistente.

**Uso:**
```jsx
import { useErrorHandler } from '../hooks/useErrorHandler'

const MyComponent = () => {
  const { error, handleError, clearError, handleAsyncError } = useErrorHandler()

  const handleClick = async () => {
    try {
      await handleAsyncError(async () => {
        // Código que puede fallar
      }, 'MyComponent.handleClick')
    } catch (error) {
      // Error ya manejado por el hook
    }
  }

  return <div>...</div>
}
```

## Implementación en App.jsx

El ErrorBoundary se aplica en múltiples niveles:

1. **ErrorBoundary global** - Envuelve toda la aplicación
2. **ErrorBoundary por componente** - Cada card tiene su propio ErrorBoundary
3. **Componente de prueba** - ErrorProneComponent para testing

## Características

### UI de Fallback
- Diseño consistente con Tailwind CSS
- Iconos descriptivos
- Botones de acción (recargar, reintentar)
- Detalles del error en desarrollo

### Logging
- Errores se loguean en consola
- Preparado para integración con Sentry
- Contexto del error incluido

### Desarrollo vs Producción
- Detalles del error solo en desarrollo
- UI simplificada en producción
- Stack trace disponible en desarrollo

## Mejores Prácticas

1. **Usar ErrorBoundary en componentes críticos**
2. **Implementar logging en producción**
3. **Proporcionar acciones de recuperación**
4. **Mantener UI de fallback simple**
5. **Testear con componentes que generen errores**

## Integración con Servicios de Monitoreo

Para integrar con Sentry u otros servicios:

```jsx
// En ErrorBoundary.jsx
componentDidCatch(error, errorInfo) {
  if (window.Sentry) {
    window.Sentry.captureException(error, { 
      extra: errorInfo,
      tags: { component: 'ErrorBoundary' }
    })
  }
}
``` 