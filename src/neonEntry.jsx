// Entry point para island styled-components - monta NeonDemo em #neon-root
// Separado para manter main.js vanilla e demonstrar styled-components isolado (<300 linhas)
import React from 'react';
import { createRoot } from 'react-dom/client';
import NeonDemo from './NeonDemo.jsx';

const el = document.getElementById('neon-root');
if (el) {
  createRoot(el).render(<NeonDemo />);
}
