/**
 * Desligar PC - Neon Protocol 2 (vanilla JS + API)
 * Style: neon-protocol-2/style.css migrado para src/input.css
 * Integra backend Express (/api/shutdown, /cancel, /shutdown-now)
 * <300 linhas, comentado
 */

// Estado global
let timerInterval = null;
let totalSeconds = 0;
let initialSeconds = 0;
let scheduled = false;

// Helpers - troca valor de input com limites
function changeValue(id, amount) {
  const input = document.getElementById(id);
  let v = parseInt(input.value) || 0;
  v += amount;
  if (id === 'minutes' || id === 'seconds') v = Math.max(0, Math.min(59, v));
  if (id === 'hours') v = Math.max(0, Math.min(99, v));
  input.value = v;
  updateCommandPreview(); // atualiza comando ao mudar
}

// Atalhos rapidos
function setTimer(h, m, s) {
  document.getElementById('hours').value = h;
  document.getElementById('minutes').value = m;
  document.getElementById('seconds').value = s;
  updateDisplay(h, m, s);
  updateCommandPreview();
}

// Atualiza display HH:MM:SS
function updateDisplay(h, m, s) {
  document.getElementById('hoursDisplay').textContent = String(h).padStart(2, '0');
  document.getElementById('minutesDisplay').textContent = String(m).padStart(2, '0');
  document.getElementById('secondsDisplay').textContent = String(s).padStart(2, '0');
}

// Preview do comando shutdown
function updateCommandPreview() {
  const h = parseInt(document.getElementById('hours').value) || 0;
  const m = parseInt(document.getElementById('minutes').value) || 0;
  const s = parseInt(document.getElementById('seconds').value) || 0;
  const sec = h * 3600 + m * 60 + s;
  const cmd = document.getElementById('commandText');
  if (cmd) cmd.textContent = `shutdown /s /t ${sec} /f`;
  // atualiza texto de progresso inicial
  const pt = document.getElementById('progressText');
  if (pt && !scheduled) pt.textContent = `${sec} // SHUTDOWN_INITIATED`;
}

// Agendar desligamento - chama backend
async function scheduleShutdown() {
  const h = parseInt(document.getElementById('hours').value) || 0;
  const m = parseInt(document.getElementById('minutes').value) || 0;
  const s = parseInt(document.getElementById('seconds').value) || 0;
  totalSeconds = h * 3600 + m * 60 + s;
  if (totalSeconds <= 0) return showMessage('Informe um tempo valido.', 'error');
  initialSeconds = totalSeconds;
  // feedback otimista
  showMessage('Agendando...', 'info');
  try {
    const res = await fetch('/api/shutdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ seconds: totalSeconds }) });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Falha ao agendar');
    // inicia countdown local
    clearInterval(timerInterval);
    scheduled = true;
    // salva para restore
    localStorage.setItem('desligar_endTime', Date.now() + totalSeconds * 1000);
    localStorage.setItem('desligar_total', initialSeconds);
    timerInterval = setInterval(() => {
      if (totalSeconds <= 0) { clearInterval(timerInterval); showMessage('Desligamento iniciado.', 'success'); scheduled = false; return; }
      totalSeconds--; updateTimer();
    }, 1000);
    showMessage('Desligamento agendado.', 'success');
    updateTimer();
    updateStatusBadge(true);
  } catch (e) {
    showMessage(e.message, 'error');
  }
}

// Atualiza timer e progresso
function updateTimer() {
  const h = Math.floor(totalSeconds / 3600);
  const m = Math.floor((totalSeconds % 3600) / 60);
  const sec = totalSeconds % 60;
  updateDisplay(h, m, sec);
  const progress = initialSeconds ? ((initialSeconds - totalSeconds) / initialSeconds) * 100 : 0;
  document.getElementById('progressBar').style.width = `${progress}%`;
  document.getElementById('progressPercent').textContent = `${Math.round(progress)}%`;
  // atualiza badge online/offline
  if (totalSeconds === 60 && Notification.permission === 'granted') {
    new Notification('Desligar PC', { body: 'Falta 1 minuto!' });
  }
}

// Cancelar
async function cancelShutdown() {
  showMessage('Cancelando...', 'info');
  try {
    const res = await fetch('/api/cancel', { method: 'POST' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error);
    clearInterval(timerInterval);
    totalSeconds = 0; scheduled = false;
    updateDisplay(0, 0, 0);
    document.getElementById('progressBar').style.width = '0%';
    document.getElementById('progressPercent').textContent = '0%';
    localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
    updateStatusBadge(false);
    showMessage('Desligamento cancelado.', 'success');
  } catch (e) {
    showMessage(e.message, 'error');
  }
}

// Desligar agora
async function shutdownNow() {
  if (!confirm('Desligar agora?')) return;
  try {
    const res = await fetch('/api/shutdown-now', { method: 'POST' });
    if (!res.ok) throw new Error('Falha');
    showMessage('Desligando agora...', 'success');
  } catch (e) { showMessage(e.message, 'error'); }
}

// Mensagem de status
function showMessage(msg, type = 'info') {
  const el = document.getElementById('statusMessage');
  if (el) el.textContent = msg;
  // cor por tipo
  if (el) el.style.color = type === 'error' ? '#ff1979' : type === 'success' ? '#00eaff' : '#72a8dd';
}

// Copiar comando
function copyCommand() {
  const cmd = document.getElementById('commandText').textContent;
  navigator.clipboard.writeText(cmd);
  showMessage('Comando copiado.', 'success');
}

// Atualiza badge Ocioso/Agendado
function updateStatusBadge(isScheduled) {
  const st = document.querySelector('.status');
  if (!st) return;
  st.innerHTML = `<i></i>${isScheduled ? 'AGENDADO' : 'OCIOSO'}`;
  st.style.borderColor = isScheduled ? '#ff008c' : '#28517e';
  st.style.color = isScheduled ? '#ff008c' : '#a9bad2';
}

// Atalho area de trabalho
async function createShortcut() {
  showMessage('Criando atalho...', 'info');
  try {
    const res = await fetch('/api/create-shortcut', { method: 'POST' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error);
    showMessage(`Atalho: ${data.path}`, 'success');
  } catch (e) { showMessage(e.message, 'error'); }
}

// Conecta footer-action botao para criar atalho
document.addEventListener('DOMContentLoaded', () => {
  // inputs mudam -> preview
  ['hours', 'minutes', 'seconds'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', updateCommandPreview);
  });
  updateCommandPreview();
  // footer botao
  const footerBtn = document.querySelector('.footer-action button');
  if (footerBtn) footerBtn.addEventListener('click', createShortcut);
  // restore
  const saved = localStorage.getItem('desligar_endTime');
  const tot = parseInt(localStorage.getItem('desligar_total') || '0');
  if (saved) {
    const rem = Math.ceil((parseInt(saved) - Date.now()) / 1000);
    if (rem > 0) {
      totalSeconds = rem; initialSeconds = tot; scheduled = true;
      timerInterval = setInterval(() => { if (totalSeconds <= 0) { clearInterval(timerInterval); return; } totalSeconds--; updateTimer(); }, 1000);
      updateStatusBadge(true); showMessage(`Restaurado: ${rem}s restantes`, 'info'); updateTimer();
    } else {
      localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
    }
  }
  // checa backend - corrige bug: se fechar e reabrir, restaura do servidor mesmo sem localStorage
  fetch('/api/status').then(r => r.json()).then(d => {
    if (d.scheduled && d.remaining > 0 && !scheduled) {
      // restaura countdown a partir do backend (fonte unica apos reload)
      totalSeconds = d.remaining;
      initialSeconds = d.total || d.remaining;
      scheduled = true;
      // recria endTime para compat com tick que nao usa, mas salva para proximos reloads
      const end = Date.now() + d.remaining * 1000;
      localStorage.setItem('desligar_endTime', end);
      localStorage.setItem('desligar_total', initialSeconds);
      clearInterval(timerInterval);
      timerInterval = setInterval(() => { if (totalSeconds <= 0) { clearInterval(timerInterval); scheduled = false; return; } totalSeconds--; updateTimer(); }, 1000);
      updateStatusBadge(true);
      showMessage(`Restaurado do sistema: ${Math.floor(d.remaining/60)}m ${d.remaining%60}s restantes`, 'info');
      updateTimer();
    } else if (d.scheduled && !scheduled) {
      showMessage('Ha agendamento no sistema', 'info');
    }
    // se backend diz nao agendado mas localStorage dizia que sim, limpa localStorage expirado
    if (!d.scheduled && scheduled && totalSeconds <= 0) {
      localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
    }
  }).catch(()=>{});
});

// Expõe para onclick inline do HTML
window.changeValue = changeValue;
window.setTimer = setTimer;
window.scheduleShutdown = scheduleShutdown;
window.cancelShutdown = cancelShutdown;
window.shutdownNow = shutdownNow;
window.copyCommand = copyCommand;
