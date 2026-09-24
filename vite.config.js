// Vite config - neon cyberpunk + React/styled-components
// Tailwind via @tailwindcss/vite, React via @vitejs/plugin-react
// Proxy /api -> localhost:3001 (Express)
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [tailwindcss(), react()],
  server: {
    port: 5173,
    proxy: {
      '/api': 'http://localhost:3001'
    }
  }
})
