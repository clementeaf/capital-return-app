import { useState, useCallback } from 'react'

/**
 * Hook personalizado para manejar errores de manera consistente
 * @returns {Object} Objeto con funciones para manejar errores
 */
export const useErrorHandler = () => {
  const [error, setError] = useState(null)

  const handleError = useCallback((error, context = '') => {
    console.error(`Error in ${context}:`, error)
    
    // Aquí puedes enviar el error a un servicio de logging
    // if (window.Sentry) {
    //   window.Sentry.captureException(error, { 
    //     tags: { context },
    //     extra: { error }
    //   })
    // }
    
    setError(error)
  }, [])

  const clearError = useCallback(() => {
    setError(null)
  }, [])

  const handleAsyncError = useCallback(async (asyncFn, context = '') => {
    try {
      return await asyncFn()
    } catch (error) {
      handleError(error, context)
      throw error
    }
  }, [handleError])

  return {
    error,
    handleError,
    clearError,
    handleAsyncError
  }
}

export default useErrorHandler 