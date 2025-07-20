import React from 'react'

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props)
    this.state = { 
      hasError: false, 
      error: null, 
      errorInfo: null 
    }
  }

  static getDerivedStateFromError(error) {
    // Actualiza el estado para que el siguiente render muestre la UI de fallback
    return { hasError: true }
  }

  componentDidCatch(error, errorInfo) {
    // Captura el error y la información del error
    this.setState({
      error: error,
      errorInfo: errorInfo
    })

    // Aquí puedes enviar el error a un servicio de logging
    console.error('ErrorBoundary caught an error:', error, errorInfo)
    
    // Opcional: Enviar a un servicio de monitoreo como Sentry
    // if (window.Sentry) {
    //   window.Sentry.captureException(error, { extra: errorInfo })
    // }
  }

  render() {
    if (this.state.hasError) {
      // UI de fallback personalizada
      return (
        <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
          <div className="max-w-md w-full">
            <div className="card text-center">
              <div className="flex justify-center mb-4">
                <div className="w-16 h-16 bg-danger-100 rounded-full flex items-center justify-center">
                  <svg className="w-8 h-8 text-danger-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
                  </svg>
                </div>
              </div>
              
              <h2 className="text-xl font-semibold text-gray-900 mb-2">
                Algo salió mal
              </h2>
              
              <p className="text-gray-600 mb-6">
                Ha ocurrido un error inesperado. Por favor, intenta recargar la página.
              </p>
              
              <div className="space-y-3">
                <button 
                  onClick={() => window.location.reload()}
                  className="btn-primary w-full"
                >
                  Recargar página
                </button>
                
                <button 
                  onClick={() => this.setState({ hasError: false, error: null, errorInfo: null })}
                  className="btn-secondary w-full"
                >
                  Intentar de nuevo
                </button>
              </div>
              
              {process.env.NODE_ENV === 'development' && this.state.error && (
                <details className="mt-6 text-left">
                  <summary className="text-sm font-medium text-gray-700 cursor-pointer mb-2">
                    Detalles del error (solo desarrollo)
                  </summary>
                  <div className="bg-gray-100 p-3 rounded text-xs font-mono text-gray-800 overflow-auto max-h-40">
                    <div className="mb-2">
                      <strong>Error:</strong>
                      <pre className="mt-1">{this.state.error.toString()}</pre>
                    </div>
                    {this.state.errorInfo && (
                      <div>
                        <strong>Stack:</strong>
                        <pre className="mt-1">{this.state.errorInfo.componentStack}</pre>
                      </div>
                    )}
                  </div>
                </details>
              )}
            </div>
          </div>
        </div>
      )
    }

    return this.props.children
  }
}

export default ErrorBoundary 