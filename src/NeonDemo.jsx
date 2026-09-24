import React, { useEffect, useState } from 'react';
import { NeonBadge, NeonFeedback } from './styled/neon.js';

// Demo component 100% styled-components - mostra uso da lib no tema cyberpunk
// Este componente é montado em #neon-root e sincroniza com o status real do app via localStorage/evento custom

export default function NeonDemo() {
  const [scheduled, setScheduled] = useState(false);
  const [msg, setMsg] = useState({ text: '◆ NEON PROTOCOL ATIVO — styled-components ◆', type: 'info' });

  useEffect(() => {
    const sync = () => {
      const end = localStorage.getItem('desligar_endTime');
      if (end && parseInt(end) > Date.now()) setScheduled(true);
      else setScheduled(false);
    };
    sync();
    const id = setInterval(sync, 1000);
    // escuta feedback do main.js via evento custom
    const handler = (e) => setMsg({ text: e.detail.text, type: e.detail.type });
    window.addEventListener('neon-feedback', handler);
    return () => { clearInterval(id); window.removeEventListener('neon-feedback', handler); };
  }, []);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', alignItems: 'center', marginTop: '8px' }}>
      <NeonBadge $scheduled={scheduled}>
        <i />
        {scheduled ? 'AGENDADO — NEON_LINK' : 'OCIOSO — STANDBY'}
      </NeonBadge>
      <NeonFeedback $type={msg.type}>{msg.text}</NeonFeedback>
      <div style={{ fontFamily: 'JetBrains Mono', fontSize: '9px', letterSpacing: '0.14em', color: 'rgba(0,240,255,0.25)' }}>
        POWERED BY <span style={{ color: '#FF00A8' }}>styled-components</span> ◆ CYBER v2.4.1
      </div>
    </div>
  );
}
