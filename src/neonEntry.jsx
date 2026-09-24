import React from 'react';
import { createRoot } from 'react-dom/client';
import NeonDemo from './NeonDemo.jsx';

const el = document.getElementById('neon-root');
if (el) {
  createRoot(el).render(<NeonDemo />);
}
