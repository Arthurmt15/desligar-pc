/**
 * Neon Protocol v2 Style - src/neon_protocol_v2_style
 * 100% do novo style consumido (Orbitron/Rajdhani, --bg-dark #070a12, --cyan-neon #00f3ff)
 * Endpoints mantidos: /api/shutdown, /cancel, /shutdown-now, /status, /create-shortcut
 */
let timerInterval = null, totalSeconds = 0, initialSeconds = 0, scheduled = false;

// Helpers compativeis com novo style (adjustValue) e antigo (changeValue)
function adjustValue(id, d) { changeValue(id, d); }
function changeValue(id, amount) {
  const el = document.getElementById(id);
  if (!el) return;
  let v = parseInt(el.value) || 0; v += amount;
  const max = id === 'hours' ? 24 : 59;
  if (v < 0) v = max; if (v > max) v = 0;
  if (id === 'hours' && max === 24) { // permite loop, mas se vier de old style que usa 99, clamp
    if (amount > 0 && v === 0 && parseInt(el.value) === 24) v = 0;
  }
  el.value = v; updateCommandPreview();
}
function setQuickTime(mins) {
  document.getElementById('hours').value = Math.floor(mins / 60);
  document.getElementById('minutes').value = mins % 60;
  document.getElementById('seconds').value = 0;
  updateDisplay(Math.floor(mins/60), mins%60, 0); updateCommandPreview();
}
function setTimer(h, m, s) { setQuickTime(h*60 + m); document.getElementById('seconds').value = s; updateDisplay(h,m,s); updateCommandPreview(); }

function updateDisplay(h, m, s) {
  const td = document.getElementById('timerDisplay');
  if (td) td.textContent = `${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`;
  // compat legada
  const hd = document.getElementById('hoursDisplay'); if (hd) hd.textContent = String(h).padStart(2,'0');
  const md = document.getElementById('minutesDisplay'); if (md) md.textContent = String(m).padStart(2,'0');
  const sd = document.getElementById('secondsDisplay'); if (sd) sd.textContent = String(s).padStart(2,'0');
}
function updateCommandPreview() {
  const h = parseInt(document.getElementById('hours').value) || 0;
  const m = parseInt(document.getElementById('minutes').value) || 0;
  const s = parseInt(document.getElementById('seconds').value) || 0;
  const sec = h*3600 + m*60 + s;
  const a = document.getElementById('cmdPreview'); if (a) a.textContent = `shutdown /s /t ${sec} /f`;
  const b = document.getElementById('commandText'); if (b) b.textContent = `shutdown /s /t ${sec} /f`;
}
function formatTime(sec){ const h=Math.floor(sec/3600), m=Math.floor((sec%3600)/60), s=sec%60; return `${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`; }

// Agendar - novo nome startTimer + alias scheduleShutdown
async function startTimer(){ return scheduleShutdown(); }
async function scheduleShutdown() {
  const h = parseInt(document.getElementById('hours').value) || 0;
  const m = parseInt(document.getElementById('minutes').value) || 0;
  const s = parseInt(document.getElementById('seconds').value) || 0;
  totalSeconds = h*3600 + m*60 + s;
  if (totalSeconds <= 0) return showMessage('Informe um tempo valido.', 'error');
  initialSeconds = totalSeconds;
  showMessage('Agendando...', 'info');
  try {
    const res = await fetch('/api/shutdown', { method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({seconds: totalSeconds}) });
    const data = await res.json(); if (!res.ok) throw new Error(data.error);
    clearInterval(timerInterval); scheduled = true;
    localStorage.setItem('desligar_endTime', Date.now() + totalSeconds*1000);
    localStorage.setItem('desligar_total', initialSeconds);
    timerInterval = setInterval(()=>{ if(totalSeconds<=0){ clearInterval(timerInterval); scheduled=false; showMessage('Desligamento iniciado.','success'); return;} totalSeconds--; updateTimer(); },1000);
    showMessage('Desligamento agendado.','success'); updateTimer(); updateStatus(true);
  } catch(e){ showMessage(e.message,'error'); }
}
function updateTimer(){
  const h=Math.floor(totalSeconds/3600), m=Math.floor((totalSeconds%3600)/60), s=totalSeconds%60;
  updateDisplay(h,m,s);
  const p = initialSeconds ? ((initialSeconds-totalSeconds)/initialSeconds)*100 : 0;
  const bar = document.getElementById('progressBar'); if(bar) bar.style.width = `${p}%`;
  const pct = document.getElementById('progressPercent'); if(pct) pct.textContent = `${Math.round(p)}%`;
  if(totalSeconds===60 && Notification.permission==='granted') new Notification('Desligar PC',{body:'Falta 1 minuto!'});
}
async function cancelTimer(){ return cancelShutdown(); }
async function cancelShutdown(){
  showMessage('Cancelando...','info');
  try{
    const res = await fetch('/api/cancel',{method:'POST'}); const data=await res.json(); if(!res.ok) throw new Error(data.error);
    clearInterval(timerInterval); totalSeconds=0; scheduled=false;
    updateDisplay(0,0,0); const bar=document.getElementById('progressBar'); if(bar) bar.style.width='0%';
    const pct=document.getElementById('progressPercent'); if(pct) pct.textContent='0%';
    localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total');
    updateStatus(false); showMessage('Desligamento cancelado.','success');
  }catch(e){ showMessage(e.message,'error'); }
}
async function shutdownNow(){
  if(!confirm('Desligar agora?')) return;
  try{ const res=await fetch('/api/shutdown-now',{method:'POST'}); if(!res.ok) throw new Error('Falha'); showMessage('Desligando agora...','success'); }catch(e){ showMessage(e.message,'error'); }
}
function showMessage(msg, type='info'){
  const el=document.getElementById('statusMessage');
  if(el){ el.style.display='block'; el.textContent=msg; el.style.color = type==='error' ? '#ff0055' : type==='success' ? '#00f3ff' : '#5a738e'; }
  // toast fallback se nao houver elemento
  if(type==='error' && !el) alert(msg);
}
function copyCommand(){ const a=document.getElementById('cmdPreview')||document.getElementById('commandText'); if(a){ navigator.clipboard.writeText(a.textContent); showMessage('Comando copiado.','success'); } }
function updateStatus(isScheduled){
  const pill=document.getElementById('statusPill');
  const txt=document.getElementById('statusText');
  if(pill && txt){ if(isScheduled){ pill.classList.add('active'); txt.textContent='AGENDADO'; } else { pill.classList.remove('active'); txt.textContent='OCIOSO'; } }
  // compat legada statusBadge/status
  const st=document.getElementById('statusBadge')||document.querySelector('.status');
  if(st){ st.innerHTML=`<i></i>${isScheduled?'AGENDADO':'OCIOSO'}`; }
}
function updateStatusBadge(b){ updateStatus(b); }
async function createIcon(){ return createShortcut(); }
async function createShortcut(){
  showMessage('Criando atalho...','info');
  try{ const res=await fetch('/api/create-shortcut',{method:'POST'}); const data=await res.json(); if(!res.ok) throw new Error(data.error); showMessage(`Atalho: ${data.path}`,'success'); }catch(e){ showMessage(e.message,'error'); }
}
document.addEventListener('DOMContentLoaded', ()=>{
  ['hours','minutes','seconds'].forEach(id=>{ const el=document.getElementById(id); if(el) el.addEventListener('input', updateCommandPreview); });
  updateCommandPreview();
  const saved=localStorage.getItem('desligar_endTime');
  const tot=parseInt(localStorage.getItem('desligar_total')||'0');
  if(saved){
    const rem=Math.ceil((parseInt(saved)-Date.now())/1000);
    if(rem>0){ totalSeconds=rem; initialSeconds=tot; scheduled=true; timerInterval=setInterval(()=>{ if(totalSeconds<=0){ clearInterval(timerInterval); scheduled=false; return;} totalSeconds--; updateTimer(); },1000); updateStatus(true); showMessage(`Restaurado: ${rem}s restantes`,'info'); updateTimer(); }
    else{ localStorage.removeItem('desligar_endTime'); localStorage.removeItem('desligar_total'); }
  }
  fetch('/api/status').then(r=>r.json()).then(d=>{
    if(d.scheduled && d.remaining>0 && !scheduled){
      totalSeconds=d.remaining; initialSeconds=d.total||d.remaining; scheduled=true;
      const end=Date.now()+d.remaining*1000;
      localStorage.setItem('desligar_endTime', end); localStorage.setItem('desligar_total', initialSeconds);
      clearInterval(timerInterval);
      timerInterval=setInterval(()=>{ if(totalSeconds<=0){ clearInterval(timerInterval); scheduled=false; return;} totalSeconds--; updateTimer(); },1000);
      updateStatus(true); showMessage(`Restaurado do sistema: ${Math.floor(d.remaining/60)}m ${d.remaining%60}s restantes`,'info'); updateTimer();
    }
  }).catch(()=>{});
});
window.adjustValue=adjustValue; window.changeValue=changeValue;
window.setQuickTime=setQuickTime; window.setTimer=setTimer;
window.startTimer=startTimer; window.scheduleShutdown=scheduleShutdown;
window.cancelTimer=cancelTimer; window.cancelShutdown=cancelShutdown;
window.shutdownNow=shutdownNow; window.copyCommand=copyCommand;
window.createIcon=createIcon; window.createShortcut=createShortcut;
window.updateStatusBadge=updateStatusBadge;
