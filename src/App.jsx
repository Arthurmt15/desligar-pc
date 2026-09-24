/**
 * App.jsx - Painel Neon Protocol 100% styled-components
 * Usa neon-protocol/web/components.js como unica fonte de estilo
 * Substitui Tailwind vanilla por styled-components, mesma logica de shutdown
 * <300 linhas, comentado por secao
 */
import React, { useState, useEffect, useRef } from 'react';
import { NeonCard, NeonButton, NeonBadge, NeonProgressWrap, NeonProgressBar, NeonFeedback, GridBg } from '../neon-protocol/web/components.js';

function formatHHMMSS(sec) {
  const h = Math.floor(sec / 3600);
  const m = Math.floor((sec % 3600) / 60);
  const s = sec % 60;
  return [h, m, s].map(v => String(v).padStart(2, '0')).join(':');
}

export default function App() {
  // Estados - horas/minutos/segundos controlados
  const [h, setH] = useState(0);
  const [m, setM] = useState(30);
  const [s, setS] = useState(0);
  const [remaining, setRemaining] = useState(0);
  const [total, setTotal] = useState(0);
  const [scheduled, setScheduled] = useState(false);
  const [feedback, setFeedback] = useState({ text: '◆ NEON PROTOCOL PRONTO ◆', type: 'info' });
  const endRef = useRef(null);
  const timerRef = useRef(null);

  const totalSec = h * 3600 + m * 60 + s;

  // Tick - atualiza countdown e progresso
  useEffect(() => {
    if (!scheduled || !endRef.current) return;
    timerRef.current = setInterval(() => {
      const rem = Math.max(0, Math.ceil((endRef.current - Date.now()) / 1000));
      setRemaining(rem);
      if (rem <= 0) {
        clearInterval(timerRef.current);
        setFeedback({ text: 'Desligando...', type: 'success' });
      } else if (rem === 60 && Notification.permission === 'granted') {
        new Notification('Desligar PC', { body: 'Falta 1 minuto!' });
      }
    }, 250);
    return () => clearInterval(timerRef.current);
  }, [scheduled]);

  // Restore de localStorage
  useEffect(() => {
    const saved = localStorage.getItem('desligar_endTime');
    const tot = parseInt(localStorage.getItem('desligar_total') || '0');
    if (saved) {
      const rem = Math.ceil((parseInt(saved) - Date.now()) / 1000);
      if (rem > 0) {
        setTotal(tot); setRemaining(rem);
        endRef.current = parseInt(saved); setScheduled(true);
        setFeedback({ text: `Restaurado: ${formatHHMMSS(rem)} restantes`, type: 'info' });
      } else {
        localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
      }
    }
    fetch('/api/status').then(r => r.json()).then(d => {
      if (d.scheduled && !scheduled) setFeedback({ text: 'Há agendamento no sistema', type: 'info' });
    }).catch(()=>{});
  }, []);

  const pct = total ? ((total - remaining) / total) * 100 : 0;

  // Acoes - agendar/cancelar/agora/atalho
  const schedule = async () => {
    if (totalSec <= 0) return setFeedback({ text: 'Defina tempo > 0', type: 'error' });
    setFeedback({ text: 'Agendando...', type: 'info' });
    try {
      const res = await fetch('/api/shutdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ seconds: totalSec }) });
      const data = await res.json(); if (!res.ok) throw new Error(data.error);
      setTotal(totalSec); setRemaining(totalSec); endRef.current = Date.now() + totalSec * 1000;
      localStorage.setItem('desligar_endTime', endRef.current); localStorage.setItem('desligar_total', totalSec);
      setScheduled(true); setFeedback({ text: `Agendado em ${formatHHMMSS(totalSec)}`, type: 'success' });
      if (Notification.permission === 'default') Notification.requestPermission();
    } catch (e) { setFeedback({ text: e.message, type: 'error' }); }
  };
  const cancel = async () => {
    setFeedback({ text: 'Cancelando...', type: 'info' });
    try {
      const res = await fetch('/api/cancel', { method: 'POST' }); const data = await res.json(); if (!res.ok) throw new Error(data.error);
      clearInterval(timerRef.current); setScheduled(false); setRemaining(0); setTotal(0); endRef.current = null;
      localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
      setFeedback({ text: 'Cancelado', type: 'success' });
    } catch (e) { setFeedback({ text: e.message, type: 'error' }); }
  };
  const now = async () => {
    if (!confirm('Desligar agora?')) return;
    const res = await fetch('/api/shutdown-now', { method: 'POST' }); if (!res.ok) setFeedback({ text: 'Falha', type: 'error' }); else setFeedback({ text: 'Desligando agora...', type: 'success' });
  };
  const shortcut = async () => {
    setFeedback({ text: 'Criando atalho...', type: 'info' });
    const res = await fetch('/api/create-shortcut', { method: 'POST' }); const data = await res.json();
    if (!res.ok) setFeedback({ text: data.error, type: 'error' }); else setFeedback({ text: `Atalho: ${data.path}`, type: 'success' });
  };

  // Helper stepper
  const step = (field, dir) => {
    if (field === 'h') setH(v => Math.min(99, Math.max(0, v + dir)));
    if (field === 'm') setM(v => Math.min(59, Math.max(0, v + dir)));
    if (field === 's') setS(v => Math.min(59, Math.max(0, v + dir)));
  };
  const preset = (mins) => { setH(Math.floor(mins/60)); setM(mins%60); setS(0); };

  return (
    <>
      <GridBg />
      <div style={{ maxWidth: '640px', margin: '0 auto', padding: '24px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
        {/* Header neon */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px', background: 'rgba(5,7,18,0.7)', borderBottom: '1px solid rgba(0,240,255,0.15)', backdropFilter: 'blur(12px)' }}>
          <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
            <div style={{ width: '44px', height: '44px', background: 'black', border: '1px solid #00F0FF', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 0 15px rgba(0,240,255,0.4)' }}>O</div>
            <div>
              <div style={{ fontFamily: 'Orbitron', fontWeight: 900, letterSpacing: '0.18em', color: 'white' }}>DESLIGAR PC // NEON</div>
              <div style={{ fontFamily: 'Share Tech Mono', fontSize: '10px', color: 'rgba(0,240,255,0.7)' }}>NEON PROTOCOL v2.4.1 <span style={{ color: '#FF00A8' }}>●</span> ONLINE</div>
            </div>
          </div>
          <NeonBadge $scheduled={scheduled}><i />{scheduled ? 'AGENDADO' : 'OCIOSO'}</NeonBadge>
        </div>

        {/* Countdown hero - 100% NeonCard */}
        <NeonCard style={{ padding: '32px', textAlign: 'center' }}>
          <div style={{ fontFamily: 'Share Tech Mono', fontSize: '10px', letterSpacing: '0.18em', color: '#00F0FF' }}>T-MINUS // TEMPO RESTANTE ◆ <span style={{ color: '#FF00A8' }}>NEON_LINK</span></div>
          <div style={{ fontFamily: 'JetBrains Mono', fontSize: '64px', fontWeight: 900, color: 'white', textShadow: '0 0 20px rgba(0,240,255,0.6)', marginTop: '12px' }}>{formatHHMMSS(remaining)}</div>
          <div style={{ fontFamily: 'Share Tech Mono', fontSize: '11px', color: 'rgba(0,240,255,0.5)', marginTop: '8px' }}>&gt; shutdown /s /t {totalSec} /f <span style={{ color: '#FF00A8' }}>[EXEC]</span></div>
          <NeonProgressWrap style={{ marginTop: '24px' }}><NeonProgressBar $pct={pct} /></NeonProgressWrap>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontFamily: 'Share Tech Mono', fontSize: '9px', color: 'rgba(0,240,255,0.3)', marginTop: '4px' }}><span>0%</span><span>100% ◆ SHUTDOWN_IMMINENT</span></div>
        </NeonCard>

        {/* Controles - presets + tempo custom */}
        <NeonCard style={{ padding: '24px' }}>
          <div style={{ fontFamily: 'Share Tech Mono', fontSize: '11px', color: '#00F0FF', fontWeight: 700, marginBottom: '12px' }}>ATALHOS RAPIDOS // QUICK_SELECT</div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: '8px', marginBottom: '16px' }}>
            {[15,30,60,120].map(v => (
              <button key={v} onClick={() => preset(v)} style={{ background: 'black', border: '1px solid rgba(0,240,255,0.2)', color: 'white', padding: '12px', fontFamily: 'JetBrains Mono', fontWeight: 700, cursor: 'pointer' }}>{v < 60 ? `${v} MIN` : v === 60 ? '01 HORA' : '02 HORAS'}</button>
            ))}
          </div>
          <div style={{ fontFamily: 'Share Tech Mono', fontSize: '11px', color: '#FF00A8', fontWeight: 700, marginBottom: '12px' }}>TEMPO PERSONALIZADO // CUSTOM_INPUT</div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: '12px' }}>
            {[
              { label: 'HORAS', v: h, f: 'h', max: 99 },
              { label: 'MINUTOS', v: m, f: 'm', max: 59, accent: true },
              { label: 'SEGUNDOS', v: s, f: 's', max: 59 },
            ].map(o => (
              <div key={o.label} style={{ background: 'black', border: o.accent ? '1px solid rgba(0,240,255,0.3)' : '1px solid rgba(0,240,255,0.1)', padding: '12px', textAlign: 'center', boxShadow: o.accent ? '0 0 20px rgba(0,240,255,0.08)' : 'none' }}>
                <div style={{ fontFamily: 'Share Tech Mono', fontSize: '9px', color: o.accent ? '#00F0FF' : 'rgba(120,220,240,0.5)' }}>{o.label}</div>
                <div style={{ display: 'flex', gap: '8px', justifyContent: 'center', marginTop: '12px', alignItems: 'center' }}>
                  <button onClick={() => step(o.f, -1)} style={{ width: '32px', height: '32px', background: '#070A14', border: '1px solid rgba(0,240,255,0.2)', color: '#00F0FF', cursor: 'pointer' }}>−</button>
                  <span style={{ fontFamily: 'JetBrains Mono', fontSize: '22px', fontWeight: 900, color: 'white', width: '40px' }}>{String(o.v).padStart(2,'0')}</span>
                  <button onClick={() => step(o.f, 1)} style={{ width: '32px', height: '32px', background: '#070A14', border: '1px solid rgba(0,240,255,0.2)', color: '#00F0FF', cursor: 'pointer' }}>+</button>
                </div>
              </div>
            ))}
          </div>
          <NeonButton onClick={schedule} style={{ marginTop: '20px' }}>AGENDAR DESLIGAMENTO ▶</NeonButton>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginTop: '12px' }}>
            <button onClick={cancel} style={{ background: 'black', border: '1px solid #FF0040', color: '#FF0040', padding: '12px', fontFamily: 'Share Tech Mono', fontWeight: 700, cursor: 'pointer' }}>CANCELAR</button>
            <button onClick={now} style={{ background: '#FFD000', border: '1px solid #FFD000', color: 'black', padding: '12px', fontFamily: 'Share Tech Mono', fontWeight: 900, cursor: 'pointer' }}>AGORA ◆</button>
          </div>
          <NeonFeedback $type={feedback.type} style={{ marginTop: '12px' }}>{feedback.text}</NeonFeedback>
        </NeonCard>

        {/* Atalho card */}
        <NeonCard style={{ padding: '16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ fontFamily: 'Share Tech Mono', fontSize: '11px', color: 'white' }}>ATALHO AREA TRABALHO <span style={{ color: 'rgba(0,240,255,0.5)' }}>1-CLICK ◆ NEON_LINK.exe</span></div>
          <button onClick={shortcut} style={{ background: 'white', color: 'black', border: '1px solid white', padding: '8px 16px', fontFamily: 'Share Tech Mono', fontWeight: 900, cursor: 'pointer' }}>CRIAR ICONE ◆</button>
        </NeonCard>
      </div>
    </>
  );
}
