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

let lastSchedule = null; // { seconds, at: Date }

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
    res.json({ ok: true, seconds: sec });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/cancel', async (req, res) => {
  try {
    await execAsync('shutdown /a');
    lastSchedule = null;
    res.json({ ok: true });
  } catch (e) {
    // shutdown /a retorna erro se não houver agendamento
    // tratamos como sucesso se mensagem indicar que não há
    if (e.message.includes('332') || e.message.toLowerCase().includes('no')) {
      lastSchedule = null;
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
  res.json({ scheduled: !!lastSchedule, lastSchedule });
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

app.listen(PORT_API, () => {
  console.log(`✅ API Desligar PC rodando em http://localhost:${PORT_API}`);
  console.log(`   Frontend dev: http://localhost:${PORT_VITE} (rode: npm run dev)`);
  console.log(`   Frontend prod: http://localhost:${PORT_API} (após npm run build + npm start)`);
});
