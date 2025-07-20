import React from 'react'
import ErrorBoundary from './ErrorBoundary'

/**
 * HOC (Higher Order Component) para envolver componentes con ErrorBoundary
 * @param {React.Component} WrappedComponent - El componente a envolver
 * @param {Object} fallbackProps - Props adicionales para el ErrorBoundary
 * @returns {React.Component} Componente envuelto con ErrorBoundary
 */
const withErrorBoundary = (WrappedComponent, fallbackProps = {}) => {
  const WithErrorBoundary = (props) => {
    return (
      <ErrorBoundary {...fallbackProps}>
        <WrappedComponent {...props} />
      </ErrorBoundary>
    )
  }

  // Copiar displayName para debugging
  WithErrorBoundary.displayName = `withErrorBoundary(${WrappedComponent.displayName || WrappedComponent.name || 'Component'})`

  return WithErrorBoundary
}

export default withErrorBoundary 