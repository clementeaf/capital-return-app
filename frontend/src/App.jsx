import { useState } from 'react'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <h1 className="text-2xl font-bold text-gray-900">
                  Capital Return App
                </h1>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <span className="badge-success">Dev</span>
              <span className="text-sm text-gray-500">
                Dashboard de AWS
              </span>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Welcome Card */}
          <div className="card animate-fade-in">
            <div className="flex items-center mb-4">
              <div className="flex-shrink-0">
                <div className="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center">
                  <svg className="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                  </svg>
                </div>
              </div>
              <div className="ml-4">
                <h2 className="text-xl font-semibold text-gray-900">
                  Bienvenido al Dashboard
                </h2>
                <p className="text-gray-600">
                  Monitorea el consumo de AWS en tiempo real
                </p>
              </div>
            </div>
            
            <div className="space-y-4">
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                <span className="text-sm font-medium text-gray-700">Contador de pruebas:</span>
                <span className="text-2xl font-bold text-primary-600">{count}</span>
              </div>
              
              <button 
                onClick={() => setCount((count) => count + 1)}
                className="btn-primary w-full"
              >
                Incrementar contador
              </button>
            </div>
          </div>

          {/* API Status Card */}
          <div className="card animate-fade-in">
            <div className="flex items-center mb-4">
              <div className="flex-shrink-0">
                <div className="w-12 h-12 bg-success-100 rounded-lg flex items-center justify-center">
                  <svg className="w-6 h-6 text-success-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
              </div>
              <div className="ml-4">
                <h2 className="text-xl font-semibold text-gray-900">
                  Estado de la API
                </h2>
                <p className="text-gray-600">
                  Verificación de conectividad
                </p>
              </div>
            </div>
            
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-sm font-medium text-gray-700">Backend Lambda:</span>
                <span className="badge-success">Conectado</span>
              </div>
              
              <div className="flex items-center justify-between">
                <span className="text-sm font-medium text-gray-700">DynamoDB:</span>
                <span className="badge-success">Activo</span>
              </div>
              
              <div className="flex items-center justify-between">
                <span className="text-sm font-medium text-gray-700">S3 Storage:</span>
                <span className="badge-success">Disponible</span>
              </div>
              
              <div className="pt-4">
                <a 
                  href="https://ghr2gobdi1.execute-api.us-east-1.amazonaws.com/dev/health" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="btn-secondary w-full text-center"
                >
                  Probar API
                </a>
              </div>
            </div>
          </div>

          {/* Quick Actions */}
          <div className="card lg:col-span-2 animate-fade-in">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">
              Acciones Rápidas
            </h2>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <button className="btn-primary">
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                Crear Recurso
              </button>
              
              <button className="btn-secondary">
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
                Ver Métricas
              </button>
              
              <button className="btn-warning">
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                Configuración
              </button>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-200 mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between">
            <div className="text-sm text-gray-500">
              © 2024 Capital Return App. Desarrollado con React + Vite + Tailwind CSS
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-xs text-gray-400">
                Ambiente: Dev
              </span>
              <span className="text-xs text-gray-400">
                Versión: 1.0.0
              </span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default App
