import React, { useState } from 'react'
import withErrorBoundary from './withErrorBoundary'

const ErrorProneComponent = () => {
  const [shouldError, setShouldError] = useState(false)

  if (shouldError) {
    throw new Error('Este es un error simulado para probar el ErrorBoundary')
  }

  return (
    <div className="card">
      <h3 className="text-lg font-semibold text-gray-900 mb-4">
        Componente de Prueba de Error
      </h3>
      
      <p className="text-gray-600 mb-4">
        Este componente puede generar errores para probar el ErrorBoundary.
      </p>
      
      <button 
        onClick={() => setShouldError(true)}
        className="btn-danger"
      >
        Generar Error
      </button>
    </div>
  )
}

// Exportar con ErrorBoundary aplicado
export default withErrorBoundary(ErrorProneComponent) 