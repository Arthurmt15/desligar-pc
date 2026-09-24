/**
 * Neon Protocol 2 - Vanilla JS + Endpoints
 * Style 100% de src/neon-protocol-2 (index.html + style.css)
 * Apenas endpoints mantidos: /api/shutdown, /cancel, /shutdown-now, /status, /create-shortcut
 * <300 linhas, comentado
 */
let timerInterval = null, totalSeconds = 0, initialSeconds = 0, scheduled = false;

// Helpers - inputs com limites 0-99 / 0-59
function changeValue(id, amount) {
  const el = document.getElementById(id);
  let v = parseInt(el.value) || 0; v += amount;
  if (id === 'minutes' || id === 'seconds') v = Math.max(0, Math.min(59, v));
  if (id === 'hours') v = Math.max(0, Math.min(99, v));
  el.value = v; updateCommandPreview();
}
function setTimer(h, m, s) {
  document.getElementById('hours').value = h;
  document.getElementById('minutes').value = m;
  document.getElementById('seconds').value = s;
  updateDisplay(h, m, s); updateCommandPreview();
}
function updateDisplay(h, m, s) {
  document.getElementById('hoursDisplay').textContent = String(h).padStart(2, '0');
  document.getElementById('minutesDisplay').textContent = String(m).padStart(2, '0');
  document.getElementById('secondsDisplay').textContent = String(s).padStart(2, '0');
}
function updateCommandPreview() {
  const h = parseInt(document.getElementById('hours').value) || 0;
  const m = parseInt(document.getElementById('minutes').value) || 0;
  const s = parseInt(document.getElementById('seconds').value) || 0;
  const sec = h * 3600 + m * 60 + s;
  const cmd = document.getElementById('commandText');
  if (cmd) cmd.textContent = `shutdown /s /t ${sec} /f`;
  const pt = document.getElementById('progressText');
  if (pt && !scheduled) pt.textContent = `${sec} // SHUTDOWN_INITIATED`;
}

// Agendar - chama backend e inicia countdown
async function scheduleShutdown() {
  const h = parseInt(document.getElementById('hours').value) || 0;
  const m = parseInt(document.getElementById('minutes').value) || 0;
  const s = parseInt(document.getElementById('seconds').value) || 0;
  totalSeconds = h * 3600 + m * 60 + s;
  if (totalSeconds <= 0) return showMessage('Informe um tempo valido.', 'error');
  initialSeconds = totalSeconds;
  showMessage('Agendando...', 'info');
  try {
    const res = await fetch('/api/shutdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ seconds: totalSeconds }) });
    const data = await res.json(); if (!res.ok) throw new Error(data.error);
    clearInterval(timerInterval); scheduled = true;
    localStorage.setItem('desligar_endTime', Date.now() + totalSeconds * 1000);
    localStorage.setItem('desligar_total', initialSeconds);
    timerInterval = setInterval(() => { if (totalSeconds <= 0) { clearInterval(timerInterval); scheduled = false; showMessage('Desligamento iniciado.', 'success'); return; } totalSeconds--; updateTimer(); }, 1000);
    showMessage('Desligamento agendado.', 'success'); updateTimer(); updateStatusBadge(true);
  } catch (e) { showMessage(e.message, 'error'); }
}
function updateTimer() {
  const h = Math.floor(totalSeconds / 3600), m = Math.floor((totalSeconds % 3600) / 60), s = totalSeconds % 60;
  updateDisplay(h, m, s);
  const progress = initialSeconds ? ((initialSeconds - totalSeconds) / initialSeconds) * 100 : 0;
  document.getElementById('progressBar').style.width = `${progress}%`;
  document.getElementById('progressPercent').textContent = `${Math.round(progress)}%`;
  if (totalSeconds === 60 && Notification.permission === 'granted') new Notification('Desligar PC', { body: 'Falta 1 minuto!' });
}
async function cancelShutdown() {
  showMessage('Cancelando...', 'info');
  try {
    const res = await fetch('/api/cancel', { method: 'POST' }); const data = await res.json(); if (!res.ok) throw new Error(data.error);
    clearInterval(timerInterval); totalSeconds = 0; scheduled = false;
    updateDisplay(0, 0, 0); document.getElementById('progressBar').style.width = '0%'; document.getElementById('progressPercent').textContent = '0%';
    localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
    updateStatusBadge(false); showMessage('Desligamento cancelado.', 'success');
  } catch (e) { showMessage(e.message, 'error'); }
}
async function shutdownNow() {
  if (!confirm('Desligar agora?')) return;
  try { const res = await fetch('/api/shutdown-now', { method: 'POST' }); if (!res.ok) throw new Error('Falha'); showMessage('Desligando agora...', 'success'); } catch (e) { showMessage(e.message, 'error'); }
}
function showMessage(msg, type = 'info') {
  const el = document.getElementById('statusMessage'); if (el) el.textContent = msg;
  if (el) el.style.color = type === 'error' ? '#ff1979' : type === 'success' ? '#00eaff' : '#72a8dd';
}
function copyCommand() {
  const cmd = document.getElementById('commandText').textContent;
  navigator.clipboard.writeText(cmd); showMessage('Comando copiado.', 'success');
}
function updateStatusBadge(isScheduled) {
  const st = document.getElementById('statusBadge') || document.querySelector('.status'); if (!st) return;
  st.innerHTML = `<i></i>${isScheduled ? 'AGENDADO' : 'OCIOSO'}`;
  st.style.borderColor = isScheduled ? '#ff008c' : '#28517e';
  st.style.color = isScheduled ? '#ff008c' : '#a9bad2';
}
async function createShortcut() {
  showMessage('Criando atalho...', 'info');
  try { const res = await fetch('/api/create-shortcut', { method: 'POST' }); const data = await res.json(); if (!res.ok) throw new Error(data.error); showMessage(`Atalho: ${data.path}`, 'success'); } catch (e) { showMessage(e.message, 'error'); }
}
document.addEventListener('DOMContentLoaded', () => {
  ['hours', 'minutes', 'seconds'].forEach(id => {
    const el = document.getElementById(id); if (el) el.addEventListener('input', updateCommandPreview);
  });
  updateCommandPreview();
  const saved = localStorage.getItem('desligar_endTime');
  const tot = parseInt(localStorage.getItem('desligar_total') || '0');
  if (saved) {
    const rem = Math.ceil((parseInt(saved) - Date.now()) / 1000);
    if (rem > 0) {
      totalSeconds = rem; initialSeconds = tot; scheduled = true;
      timerInterval = setInterval(() => { if (totalSeconds <= 0) { clearInterval(timerInterval); scheduled = false; return; } totalSeconds--; updateTimer(); }, 1000);
      updateStatusBadge(true); showMessage(`Restaurado: ${rem}s restantes`, 'info'); updateTimer();
    } else { localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total'); }
  }
  fetch('/api/status').then(r => r.json()).then(d => {
    if (d.scheduled && d.remaining > 0 && !scheduled) {
      totalSeconds = d.remaining; initialSeconds = d.total || d.remaining; scheduled = true;
      const end = Date.now() + d.remaining * 1000;
      localStorage.setItem('desligar_endTime', end); localStorage.setItem('desligar_total', initialSeconds);
      clearInterval(timerInterval);
      timerInterval = setInterval(() => { if (totalSeconds <= 0) { clearInterval(timerInterval); scheduled = false; return; } totalSeconds--; updateTimer(); }, 1000);
      updateStatusBadge(true); showMessage(`Restaurado do sistema: ${Math.floor(d.remaining/60)}m ${d.remaining%60}s restantes`, 'info'); updateTimer();
    } else if (d.scheduled && !scheduled) showMessage('Ha agendamento no sistema', 'info');
  }).catch(()=>{});
});
window.changeValue = changeValue; window.setTimer = setTimer;
window.scheduleShutdown = scheduleShutdown; window.cancelShutdown = cancelShutdown;
window.shutdownNow = shutdownNow; window.copyCommand = copyCommand; window.createShortcut = createShortcut;
