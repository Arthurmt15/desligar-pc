// Vite config - Neon Protocol 2 (vanilla)
// Proxy /api -> localhost:3001 (Express) - apenas endpoints mantidos
import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    port: 5173,
    proxy: {
      '/api': 'http://localhost:3001'
    }
  }
})
