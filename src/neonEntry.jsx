// Entry Neon Protocol - agora monta App completo 100% styled-components
// Fonte unica: neon-protocol/web/components.js
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';

// Monta no #root (novo) ou #neon-root (legado) para compatibilidade
const el = document.getElementById('root') || document.getElementById('neon-root');
if (el) {
  // Limpa conteudo vanilla se for root principal
  if (el.id === 'root') el.innerHTML = '';
  createRoot(el).render(<App />);
}
