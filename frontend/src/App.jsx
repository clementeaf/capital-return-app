import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="App">
      <header className="App-header">
        <h1>Capital Return App</h1>
        <p>Aplicación para gestión de retornos de capital</p>
        
        <div className="card">
          <button onClick={() => setCount((count) => count + 1)}>
            Contador: {count}
          </button>
          <p>
            Edita <code>src/App.jsx</code> y guarda para probar HMR
          </p>
        </div>
        
        <p className="read-the-docs">
          Haz clic en los enlaces de Vite y React para aprender más
        </p>
      </header>
    </div>
  )
}

export default App
