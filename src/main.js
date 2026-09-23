const $ = (s) => document.querySelector(s);

const els = {
  hours: $('#input-hours'),
  minutes: $('#input-minutes'),
  seconds: $('#input-seconds'),
  countdown: $('#countdown'),
  progress: $('#progress-bar'),
  badge: $('#status-badge'),
  preview: $('#command-preview'),
  feedback: $('#feedback'),
  btnSchedule: $('#btn-schedule'),
  btnCancel: $('#btn-cancel'),
  btnNow: $('#btn-now'),
  btnShortcut: $('#btn-shortcut'),
};

let timer = null;
let endTime = null;
let totalSeconds = 0;
let scheduled = false;

// --- helpers ---
function getTotalSeconds() {
  const h = parseInt(els.hours.value) || 0;
  const m = parseInt(els.minutes.value) || 0;
  const s = parseInt(els.seconds.value) || 0;
  return h * 3600 + m * 60 + s;
}

function formatHHMMSS(sec) {
  const h = Math.floor(sec / 3600);
  const m = Math.floor((sec % 3600) / 60);
  const s = sec % 60;
  return [h, m, s].map(v => String(v).padStart(2, '0')).join(':');
}

function updatePreview() {
  const sec = getTotalSeconds();
  els.preview.textContent = `shutdown /s /t ${sec} /f`;
}

function setFeedback(msg, type = 'info') {
  els.feedback.textContent = msg;
  els.feedback.className = 'text-sm text-center min-h-[20px] ' + (
    type === 'error' ? 'text-red-400' :
    type === 'success' ? 'text-emerald-400' :
    'text-zinc-400'
  );
}

function setBadge(scheduled) {
  if (scheduled) {
    els.badge.innerHTML = '<span class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span> Agendado';
    els.badge.className = 'inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium bg-amber-500/10 border border-amber-500/20 text-amber-400';
  } else {
    els.badge.innerHTML = '<span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span> Ocioso';
    els.badge.className = 'inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium bg-zinc-900 border border-zinc-800 text-zinc-400';
  }
}

function startCountdown(seconds) {
  totalSeconds = seconds;
  endTime = Date.now() + seconds * 1000;
  scheduled = true;
  localStorage.setItem('desligar_endTime', endTime);
  localStorage.setItem('desligar_total', totalSeconds);
  setBadge(true);
  els.btnCancel.disabled = false;
  els.btnSchedule.disabled = true;
  els.btnSchedule.classList.add('opacity-50', 'cursor-not-allowed');

  if (timer) clearInterval(timer);
  timer = setInterval(tick, 250);
  tick();
}

function stopCountdown() {
  scheduled = false;
  endTime = null;
  totalSeconds = 0;
  localStorage.removeItem('desligar_endTime');
  localStorage.removeItem('desligar_total');
  if (timer) clearInterval(timer);
  els.countdown.textContent = '00:00:00';
  els.progress.style.width = '0%';
  setBadge(false);
  els.btnCancel.disabled = true;
  els.btnSchedule.disabled = false;
  els.btnSchedule.classList.remove('opacity-50', 'cursor-not-allowed');
}

function tick() {
  if (!endTime) return;
  const remaining = Math.max(0, Math.ceil((endTime - Date.now()) / 1000));
  els.countdown.textContent = formatHHMMSS(remaining);
  const pct = totalSeconds ? ((totalSeconds - remaining) / totalSeconds) * 100 : 0;
  els.progress.style.width = `${pct}%`;

  if (remaining <= 0) {
    clearInterval(timer);
    els.countdown.textContent = '00:00:00';
    // mantém badge como agendado até PC desligar
  }
  if (remaining === 60) {
    // opcional: notificação
    if ('Notification' in window && Notification.permission === 'granted') {
      new Notification('Desligar PC', { body: 'Falta 1 minuto para desligar!' });
    }
  }
}

// --- events ---
['input', 'change'].forEach(evt => {
  [els.hours, els.minutes, els.seconds].forEach(el => el.addEventListener(evt, updatePreview));
});

// stepper
document.querySelectorAll('[data-step]').forEach(btn => {
  btn.addEventListener('click', () => {
    const field = btn.dataset.step;
    const dir = parseInt(btn.dataset.dir);
    const map = { hours: els.hours, minutes: els.minutes, seconds: els.seconds };
    const el = map[field];
    let val = parseInt(el.value) || 0;
    val += dir;
    const max = field === 'hours' ? 99 : 59;
    if (val < 0) val = 0;
    if (val > max) val = max;
    el.value = val;
    updatePreview();
  });
});

// presets
document.querySelectorAll('.preset-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const mins = parseInt(btn.dataset.preset);
    const h = Math.floor(mins / 60);
    const m = mins % 60;
    els.hours.value = h;
    els.minutes.value = m;
    els.seconds.value = 0;
    updatePreview();
    // highlight
    document.querySelectorAll('.preset-btn').forEach(b => b.classList.remove('bg-violet-600', 'border-violet-500', 'text-white'));
    btn.classList.add('bg-violet-600', 'border-violet-500', 'text-white');
    setTimeout(() => btn.classList.remove('bg-violet-600', 'border-violet-500', 'text-white'), 600);
  });
});

// schedule
els.btnSchedule.addEventListener('click', async () => {
  const seconds = getTotalSeconds();
  if (seconds <= 0) return setFeedback('Defina um tempo maior que 0 segundos.', 'error');
  if (seconds > 315360000) return setFeedback('Tempo máximo é 10 anos.', 'error');

  els.btnSchedule.disabled = true;
  setFeedback('Agendando...');

  try {
    const res = await fetch('/api/shutdown', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ seconds })
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Falha ao agendar');
    startCountdown(seconds);
    setFeedback(`Desligamento agendado em ${formatHHMMSS(seconds)} ✔`, 'success');
    if ('Notification' in window && Notification.permission === 'default') Notification.requestPermission();
  } catch (e) {
    setFeedback(e.message, 'error');
    els.btnSchedule.disabled = false;
  }
});

// cancel
els.btnCancel.addEventListener('click', async () => {
  setFeedback('Cancelando...');
  try {
    const res = await fetch('/api/cancel', { method: 'POST' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Falha ao cancelar');
    stopCountdown();
    setFeedback('Desligamento cancelado ✔', 'success');
  } catch (e) {
    setFeedback(e.message, 'error');
  }
});

// now
els.btnNow.addEventListener('click', async () => {
  if (!confirm('Desligar o PC agora?')) return;
  try {
    const res = await fetch('/api/shutdown-now', { method: 'POST' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Falha');
    setFeedback('Desligando agora...', 'success');
  } catch (e) {
    setFeedback(e.message, 'error');
  }
});

// shortcut
els.btnShortcut.addEventListener('click', async () => {
  els.btnShortcut.disabled = true;
  els.btnShortcut.textContent = 'Criando...';
  try {
    const res = await fetch('/api/create-shortcut', { method: 'POST' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Falha ao criar atalho');
    setFeedback(`Atalho criado em: ${data.path} ✔`, 'success');
    els.btnShortcut.textContent = 'Criado ✔';
    setTimeout(() => { els.btnShortcut.textContent = 'Criar ícone'; els.btnShortcut.disabled = false; }, 2500);
  } catch (e) {
    setFeedback(e.message, 'error');
    els.btnShortcut.textContent = 'Criar ícone';
    els.btnShortcut.disabled = false;
  }
});

// restore
(function restore() {
  updatePreview();
  const saved = localStorage.getItem('desligar_endTime');
  const total = parseInt(localStorage.getItem('desligar_total') || '0');
  if (saved) {
    const remaining = Math.ceil((parseInt(saved) - Date.now()) / 1000);
    if (remaining > 0) {
      totalSeconds = total;
      endTime = parseInt(saved);
      scheduled = true;
      setBadge(true);
      els.btnCancel.disabled = false;
      els.btnSchedule.disabled = true;
      if (timer) clearInterval(timer);
      timer = setInterval(tick, 250);
      tick();
      setFeedback(`Agendamento restaurado: ${formatHHMMSS(remaining)} restantes`, 'info');
    } else {
      localStorage.removeItem('desligar_endTime');
      localStorage.removeItem('desligar_total');
    }
  }

  // checa status no backend
  fetch('/api/status').then(r => r.json()).then(d => {
    if (d.scheduled && !scheduled) {
      // backend tem agendamento mas frontend não -> sincroniza UI
      // não temos remaining exato, então só mostra badge
      setFeedback('Há um desligamento agendado no sistema.', 'info');
      els.btnCancel.disabled = false;
    }
  }).catch(() => {});
})();
