/**
 * API Desligar PC - Express na porta 3001
 * Endpoints: /api/shutdown, /api/cancel, /api/shutdown-now, /api/status, /api/create-shortcut
 * Executa comandos Windows shutdown /s /t /a via exec.
 * Serve dist/ em producao ou redireciona para Vite em dev.
 * Limite: 143 linhas, comentado por rota.
 */
import express from 'express';
import cors from 'cors';
import { exec } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const PROJECT_ROOT = path.resolve(__dirname, '..');
const PORT_API = 3001;
const PORT_VITE = 5173;

const app = express();
app.use(cors());
app.use(express.json());

// Serve frontend built or src
const distPath = path.join(PROJECT_ROOT, 'dist');
if (fs.existsSync(distPath)) {
  app.use(express.static(distPath));
}

// Persistencia para sobreviver a restart do server (Windows shutdown persiste)
const scheduleFile = path.join(PROJECT_ROOT, 'server', '.schedule.json');
let lastSchedule = null; // { seconds, at: Date }
try {
  if (fs.existsSync(scheduleFile)) {
    const j = JSON.parse(fs.readFileSync(scheduleFile, 'utf8'));
    lastSchedule = { seconds: j.seconds, at: new Date(j.at) };
    // expira se ja passou
    const rem = lastSchedule.seconds - Math.floor((Date.now() - lastSchedule.at) / 1000);
    if (rem <= 0) { lastSchedule = null; try { fs.unlinkSync(scheduleFile); } catch {} }
  }
} catch {}
function saveSchedule() {
  try {
    if (lastSchedule) fs.writeFileSync(scheduleFile, JSON.stringify({ seconds: lastSchedule.seconds, at: lastSchedule.at }), 'utf8');
    else try { fs.unlinkSync(scheduleFile); } catch {}
  } catch {}
}

function execAsync(cmd) {
  return new Promise((resolve, reject) => {
    exec(cmd, (err, stdout, stderr) => {
      if (err) reject(new Error(stderr || err.message));
      else resolve(stdout);
    });
  });
}

app.post('/api/shutdown', async (req, res) => {
  const { seconds } = req.body;
  const sec = parseInt(seconds);
  if (isNaN(sec) || sec <= 0 || sec > 315360000) {
    return res.status(400).json({ error: 'Tempo inválido. Use 1 a 315360000 segundos.' });
  }
  try {
    // /f força fechamento, necessário quando t > 0
    await execAsync(`shutdown /s /t ${sec} /f`);
    lastSchedule = { seconds: sec, at: new Date() };
    saveSchedule();
    res.json({ ok: true, seconds: sec });
  } catch (e) {
    // Se ja ha agendamento (1190), cancela e tenta novamente - corrige bug de persistencia
    if (e.message.includes('1190') || e.message.toLowerCase().includes('ja foi agendado') || e.message.toLowerCase().includes('already')) {
      try {
        await execAsync('shutdown /a');
        await execAsync(`shutdown /s /t ${sec} /f`);
        lastSchedule = { seconds: sec, at: new Date() };
        saveSchedule();
        return res.json({ ok: true, seconds: sec, note: 'Reagendado apos cancelar anterior' });
      } catch (e2) { return res.status(500).json({ error: e2.message }); }
    }
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/cancel', async (req, res) => {
  try {
    await execAsync('shutdown /a');
    lastSchedule = null; saveSchedule();
    res.json({ ok: true });
  } catch (e) {
    // shutdown /a retorna erro se não houver agendamento
    // tratamos como sucesso se mensagem indicar que não há
    if (e.message.includes('332') || e.message.toLowerCase().includes('no')) {
      lastSchedule = null; saveSchedule();
      return res.json({ ok: true, note: 'Nenhum agendamento ativo' });
    }
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/shutdown-now', async (req, res) => {
  try {
    await execAsync('shutdown /s /t 0 /f');
    res.json({ ok: true });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/status', (req, res) => {
  if (!lastSchedule) return res.json({ scheduled: false, remaining: 0, total: 0 });
  const remaining = lastSchedule.seconds - Math.floor((Date.now() - lastSchedule.at) / 1000);
  if (remaining <= 0) { lastSchedule = null; saveSchedule(); return res.json({ scheduled: false, remaining: 0, total: 0 }); }
  res.json({ scheduled: true, remaining, total: lastSchedule.seconds, lastSchedule });
});

app.post('/api/create-shortcut', async (req, res) => {
  try {
    const desktop = await getDesktopPath();
    const targetBat = path.join(PROJECT_ROOT, 'iniciar-desligar.bat');
    const shortcutPath = path.join(desktop, 'Desligar PC.lnk');
    const iconPath = path.join(PROJECT_ROOT, 'icon.ico'); // opcional

    // Cria .bat que inicia o servidor e abre o navegador
    // Usa start para abrir em janela separada
    const batContent = `@echo off
REM Atalho Desligar PC - inicia servidor e abre painel
cd /d "${PROJECT_ROOT}"
echo Iniciando painel Desligar PC...
start "" http://localhost:${PORT_API}
node server/server.js
pause
`;
    fs.writeFileSync(targetBat, batContent, 'utf8');

    // Cria .lnk via PowerShell
    // Se icon.ico não existir, usa ícone padrão do shell32
    const iconTarget = fs.existsSync(iconPath) ? iconPath : 'C:\\Windows\\System32\\shell32.dll,27';
    const psScript = `
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("${shortcutPath.replace(/\\/g, '\\\\')}")
$Shortcut.TargetPath = "${targetBat.replace(/\\/g, '\\\\')}"
$Shortcut.WorkingDirectory = "${PROJECT_ROOT.replace(/\\/g, '\\\\')}"
$Shortcut.Description = "Painel Desligar PC"
$Shortcut.IconLocation = "${iconTarget.replace(/\\/g, '\\\\')}"
$Shortcut.Save()
Write-Output "OK"
`;
    const psFile = path.join(PROJECT_ROOT, 'tmp_create_shortcut.ps1');
    fs.writeFileSync(psFile, psScript, 'utf8');

    await execAsync(`powershell -ExecutionPolicy Bypass -File "${psFile}"`);
    // cleanup ps file
    try { fs.unlinkSync(psFile); } catch {}

    if (!fs.existsSync(shortcutPath)) throw new Error('Falha ao criar .lnk');

    res.json({ ok: true, path: shortcutPath, bat: targetBat });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

function getDesktopPath() {
  return execAsync('powershell -Command "[Environment]::GetFolderPath(\'Desktop\')"').then(out => out.trim());
}

// Fallback para SPA quando dist existe
app.get('*', (req, res) => {
  const index = path.join(distPath, 'index.html');
  if (fs.existsSync(index)) return res.sendFile(index);
  // em dev, redireciona para Vite
  res.redirect(`http://localhost:${PORT_VITE}`);
});

// Cores neon para logs - usa ANSI cyan/pink da paleta neon-protocol/tokens.json
const c = { cyan: '\x1b[36m', pink: '\x1b[35m', dim: '\x1b[2m', reset: '\x1b[0m' };
app.listen(PORT_API, () => {
  console.log(`${c.cyan}◆ NEON PROTOCOL v2.4.1 ◆${c.reset} API rodando em http://localhost:${PORT_API}`);
  console.log(`${c.dim}  Frontend dev: http://localhost:${PORT_VITE} (npm run dev)${c.reset}`);
  console.log(`${c.pink}  Frontend prod: http://localhost:${PORT_API} (apos build)${c.reset} ${c.cyan}[tokens: neon-protocol/tokens.json]${c.reset}`);
});
